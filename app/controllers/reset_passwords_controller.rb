class ResetPasswordsController < ApplicationController
  def edit
    @user = User.find_by token: params[:token]
    @user ? render(:edit) : redirect_to(invalid_token_path)
  end

  def update
    user = User.find_by token: params[:token]
    if user
      user.update_attribute :password, params[:user][:password]
      user.clear_token!
      flash[:notice] = 'Successfully updated your password.'
      redirect_to login_path
    else
      redirect_to invalid_token_path
    end
  end
end
