class UsersController < ApplicationController
  before_action :require_logout, except: [:show]
  before_action :require_login, only: [:show]

  def new
    @user = User.new
    @invitation = Invitation.find_by token: params[:token]
  end

  def create
    @invitation = Invitation.find_by token: user_params[:invite_token]
    @user = User.new user_params.except :invite_token
    if @user.save
      make_mutually_follow(@invitation.inviter, @user) if @invitation
      AppMailer.welcome_user_upon_registration(@user).deliver
      redirect_to login_path, notice: "Successfully registered! Please login, #{@user.full_name}"
    else
      flash.now[:error] = 'Your submission contains validation errors. Please fix the highlighted fields before submitting again.'
      render :new
    end
  end

  def show
    @user = User.find_by slug: params[:id]
  end

  private

  def user_params
    params.require(:user).permit :full_name, :email, :password, :invite_token
  end

  def make_mutually_follow(user_1, user_2)
    Follow.create [{ follower: user_1, guide: user_2 },{ follower: user_2, guide: user_1 }]
  end
end
