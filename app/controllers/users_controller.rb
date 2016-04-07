class UsersController < ApplicationController
  before_action :require_logout, except: [:show]
  before_action :require_login, only: [:show]

  def new
    @user = User.new
    @invitation = Invitation.find_by token: params[:token]
  end

  def create
    @user = User.new user_params
    charge_options = { amount: 999, token: params[:stripeToken], description: "First-month subscription fee for #{@user.full_name}" }
    charge = StripeWrapper::Charge.create charge_options if @user.valid?
    if !charge
      flash.now[:error] = 'Your submission contains validation errors. Please fix the highlighted fields before submitting again.'
      render :new
    elsif charge.successful?
      @user.save
      @invitation = Invitation.find_by token: params[:invite_token] if params[:invite_token]
      make_mutually_follow(@invitation.inviter, @user) if @invitation
      AppMailer.delay.welcome_user_upon_registration(@user.id)
      redirect_to login_path, notice: "Successfully registered! Please login, #{@user.full_name}"
    else
      flash[:error] = charge.error_message
      redirect_to register_path
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
    user_1.follow! user_2
    user_2.follow! user_1
  end
end
