class UsersController < ApplicationController
  before_action :require_logout

  def new
    @user = User.new
  end

  def create
    @user = User.create user_params
    if @user.valid?
      redirect_to login_path, notice: "Successfully registered! Please login, #{@user.full_name}"
    else
      flash.now[:error] = 'Your submission contains validation errors. Please fix the highlighted fields before submitting again.'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :full_name, :email, :password
  end
end
