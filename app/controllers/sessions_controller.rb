class SessionsController < ApplicationController
  before_action :require_logout, except: [:destroy]

  def create
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "Welcome, #{user.full_name}!"
    else
      flash.now[:error] = 'Oops! There was something wrong with your login credentials. Try again?'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully logged out.'
  end
end
