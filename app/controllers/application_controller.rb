class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    @current_user ||= User.find session[:user_id] if logged_in?
  end

  def require_login
    redirect_to login_path, notice: 'You must log in first!' unless logged_in?
  end

  def require_logout
    redirect_to home_path, notice: 'You are already logged in!' if logged_in?
  end

end
