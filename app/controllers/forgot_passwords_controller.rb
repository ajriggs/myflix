class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by email: params[:email]
    if user
      user.render_token!
      AppMailer.delay.notify_user_of_password_reset(user)
      redirect_to email_confirmed_path
    else
      flash[:error] = 'The email you provided is not registered with myflix. Please try again.'
      redirect_to forgot_password_path
    end
  end
end
