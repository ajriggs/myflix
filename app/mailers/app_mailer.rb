class AppMailer < ActionMailer::Base
  default from: 'info@myflix.com'

  def welcome_user_upon_registration(user)
    @user = user
    mail to: user.email, subject: 'Welcome to Myflix!'
  end

  def notify_user_of_password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password Reset'
  end

  def invite_to_register(invitation)
    @invitation = invitation
    mail to: @invitation.email, subject: "#{@invitation.inviter_name} invited you to join myflix!"
  end
end
