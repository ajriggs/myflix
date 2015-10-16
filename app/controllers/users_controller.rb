class UsersController < ApplicationController
  def register
    @user = User.new
    render :register
  end

  def create
    @user = User.create(params.require(:user).permit(:full_name, :email, :password))
    if @user.valid?
      redirect_to login_path, notice: "Successfully registered! Please login, #{@user.full_name}"
    else
      flash[:error] = 'Your submission contains validation errors. Please fix the highlighted fields before submitting again.'
      render :register
    end
  end
end
