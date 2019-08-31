class UsersController < ApplicationController

  def index

    @is_signed_in = self.signed_in

    @is_activated = false
    if @is_signed_in
      the_user = User.where({ :id => session[:user_id] }).first
      @is_activated = the_user.account_activated
    end

    @users = User.current_users
    respond_to do |format|
      format.json {
        json_users = @users.map {|x| display_json(x) }
        render({ :plain => json_users.to_json })
      }
      format.html {
        render({ :template => 'users/index' })
      }
    end
  end


  def show

    @is_signed_in = self.signed_in

    if @is_signed_in == false
      add_flash :danger, "You must be signed in to view a user. You can sign in <a href='/sign_in'>here</a>."
      redirect_to("/")
      return
    end

    @user = User.where("(id = #{params[:user_id]}) AND (soft_deleted_at IS NULL)").first

    respond_to do |format|
      format.json {
        json_user = display_json(@user)
        render({ :plain => json_user.to_json })
        return
      }
      format.html {
        render({ :template => 'users/show' })
      }
    end
  end
  
  def logout
    session.delete(:user_id)
    add_flash :success, "You've signed out! 👋"
    redirect_to("/")
  end

  def registration_form
    is_signed_in = self.signed_in
    render({ :template => 'users/sign_up_form' })
  end

  def login_form
    is_signed_in = self.signed_in
    render({ :template => 'users/sign_in_form'})
  end

  def login_user
    # sign out any currently signed in user
    session.delete(:user_id)

    if params[:qs_password] == nil
      add_flash :danger, "You must enter a password."
      redirect_back(fallback_location: "/sign_in")
      return
    end

    # check whether a user exists
    the_user = User.where({ :email => params[:qs_email] })
    if (the_user.length == 0) || (the_user[0].password_hash != (BCrypt::Engine.hash_secret params[:qs_password], the_user[0].salt))
      add_flash :danger, "Uh oh, something went wrong."
      redirect_to("/")
      return
    end

    # now check whether the submitted password is good
    session[:user_id] = the_user[0][:id]
    add_flash :success, "Hi #{the_user[0][:first_name]}!"
    redirect_to("/")

  end

  def forgot_form
    render({ :template => 'users/forgot_password_form'})
  end

  def create

    # variable that will function as a quality check
    needs_redirect = false

    # perform validations
    if params[:qs_first_name].blank?
      add_flash :danger, "You must provide your first name!"
      needs_redirect = true
    end

    if params[:qs_last_name].blank?
      add_flash :danger, "You must provide your last name!"
      needs_redirect = true
    end

    if params[:qs_email].blank?
      add_flash :danger, "You must provide an email address!"
      needs_redirect = true
    elsif /^[^\s@]+@[^\s@]+\.edu+$/.match(params[:qs_email].strip) == nil
      # this is a check for a .edu email address
      add_flash :danger, "You must provide a valid .edu email address!"
      needs_redirect = true
    end

    if params[:qs_password].blank? || params[:qs_password_confirm].blank? || params[:qs_password] != params[:qs_password_confirm]
      add_flash :danger, "There was an issue with the passwords you provided. Please fill in the password and password confirmation with matching passwords."
      needs_redirect = true
    end

    check_user = User.where({ :email => params[:qs_email].strip })
    if check_user.length > 0
      add_flash :danger, "You've already signed up!"
      needs_redirect = true
    end

    if needs_redirect
      redirect_to("/sign_up")
      return
    end

    # we made it this far so we must have valid data and no user exists with this email address

    the_user = User.new
    the_user.first_name = params[:qs_first_name].strip
    the_user.last_name = params[:qs_last_name].strip
    the_user.email = params[:qs_email].strip
    if params[:qs_gender] == "male"
      the_user.gender = "male"
    elsif params[:qs_gender] == "female"
      the_user.gender = "female"
    end
    the_user.salt = BCrypt::Engine.generate_salt
    the_user.password_hash = BCrypt::Engine.hash_secret params[:qs_password], the_user.salt
    the_user.activation_token = SecureRandom.uuid
    the_user.activation_expiry = Time.now.utc + 2*60*60

    added_user = the_user.save
    
    if added_user
      UserMailer.welcome_email(the_user).deliver
      session[:user_id] = the_user.id
      add_flash :success, "Hi #{the_user.first_name.strip}! Thanks for signing up 🚀😃️"
      redirect_to("/users/#{the_user.id}")
      return
    else
      session.delete(:user_id)
      add_flash :danger, "Uh oh, something went wrong... try again! 😠"
      redirect_to("/sign_up")
      return
    end

  end

  def activation_screen

    is_signed_in = self.signed_in

    if is_signed_in
      session.delete(:user_id)
    end

    the_user = User.where({ :id => params[:user_id], :activation_token => params[:activation_token] })

    if the_user.length == 0
      add_flash :danger, "Uh oh! something went wrong."
      redirect_to("/sign_up")
      return
    end

    @the_user = the_user[0]

    @expired_token = false
    if DateTime.now.utc > @the_user.activation_expiry
      @expired_token = true
      add_flash :danger, "Your activation link has expired."
      render({ :template => "users/activation_expired_screen" })
    else
      @the_user.account_activated = true
      @the_user.save
      session[:user_id] = @the_user.id
      add_flash :success, "Congrats, you've activated your account❗😃"
      redirect_to("/")
    end

  end

  def regenerate_activation
    the_user = User.where({ :id => params[:user_id] })

    if the_user.length == 0
      add_flash :danger, "Uh oh, something went wrong."
      redirect_to("/")
      return
    end

    the_user = the_user[0]

    if params[:activation_token] != the_user.activation_token
      add_flash :danger, "Uh oh, something went wrong."
      redirect_to("/")
      return
    end

    # if we made it this far, then there is a user with a valid activation token

    if the_user.account_activated
      add_flash :warning, "Your account is already activated."
      redirect_to("/")
      return
    end

    # ok, at this point we've got a valid inactive user who needs an updated activation token
    the_user.activation_token = SecureRandom.uuid
    the_user.update_expiry(:activation_expiry)
    UserMailer.welcome_email(the_user).deliver
    add_flash :success, "Check your email for a new activation link!"
    redirect_to "/"

  end

  def display_json(the_user)
    for_display = {
        :id => the_user[:id] == nil ? the_user["id"] : the_user[:id],
        :email  => the_user[:email] == nil ? the_user["email"] : the_user[:email],
        :name => the_user[:name] == nil ? the_user["first_name"].strip + " " + the_user["last_name"].strip : the_user[:name],
        :gender => the_user[:gender] == nil ? the_user["gender"] : the_user[:gender]
    }
    if ((the_user[:current_city] != "not provided") && (the_user[:current_city] != nil))
      for_display[:current_city] = the_user[:current_city]
    end
    if ((the_user[:destination_city] != "not provided") && (the_user[:destination_city] != nil))
      for_display[:destination_city] = the_user[:destination_city]
    end
    return for_display
  end

end
