class AppMailer < ActionMailer
  def welcome_user_upon_registration(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to myflix!'

  end
end
