class AppMailer < ActionMailer::Base
  def welcome_user_upon_registration(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to Myflix!'
  end
end
