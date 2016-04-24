class UsersController < ApplicationController
  before_action :require_logout, except: [:show]
  before_action :require_login, only: [:show]

  def new
    @user = User.new
    @invitation = Invitation.find_by token: params[:token]
  end

  def create
    @user = User.new user_params
    registration = UserRegistration.new(@user).register params[:stripeToken]
    if registration.successful?
      registration.handle_invite params[:invite_token]
      redirect_to login_path, notice: "Successfully registered! Please login, #{@user.full_name}"
    else
      flash[:error] = registration.error_message
      render :new
    end
  end
  
  def show
    @user = User.find_by slug: params[:id]
  end

  private

  def user_params
    params.require(:user).permit :full_name, :email, :password
  end
end
