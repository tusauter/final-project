class ApplicationController < ActionController::Base
  
  skip_before_action :verify_authenticity_token, raise: false
  
  def signed_in
    # check for a session user_id
    if session[:user_id] == nil
      return false
    end

    # if there is no user with that id, sign them out
    if User.where({ :id => session[:user_id] }).length == 0
      session.delete(:user_id)
      return false
    end

    # looks like we've got a valid user
    return true
  end

  def add_flash(flash_type, flash_message)
    if flash.key?(flash_type)
      flash[flash_type].push flash_message
    else
      flash[flash_type] = [flash_message]
    end
  end
  
  
end
