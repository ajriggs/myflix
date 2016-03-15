class ConnectionsController < ApplicationController
  before_action :require_login

  def index
    @connections = current_user.following_connections
  end

  def destroy
    @connection = Connection.find params[:id]
    @connection.delete if @connection.follower == current_user
    redirect_to people_path
  end

  def create
    guide = User.find_by slug: params[:user_id]
    connection = Connection.new(follower: current_user, guide: guide)
    connection.save unless current_user.cannot_follow? guide
    redirect_to people_path
  end
end
