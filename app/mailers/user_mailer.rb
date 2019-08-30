class UserMailer < ActionMailer::Base

  default from: "Trace <" + ENV.fetch("GMAIL_USERNAME") + ">"

  def welcome_email(user)
    @user = user
    puts "about to send email to #{@user.first_name}"
    mail(:to => @user.email,
         :subject => "Welcome to the MBA Apartment Swap")
  end

end
