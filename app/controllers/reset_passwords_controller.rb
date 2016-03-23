class ResetPasswordsController < ApplicationController
  def edit
    @user = User.find_by token: params[:token]
    @user ? render(:edit) : redirect_to(invalid_token_path)
  end

  def update
    @user = User.find_by token: params[:token]
    return redirect_to invalid_token_path unless @user
    @user.password = params[:user][:password]
    @user.token = nil
    if @user.save
      flash[:notice] = 'Successfully updated your password.'
      redirect_to login_path
    else
      @user.reload
      flash.now[:error] = 'Your password was not valid. Please try again.'
      render :edit
    end
  end
end
