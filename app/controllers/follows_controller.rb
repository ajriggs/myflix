class FollowsController < ApplicationController
  before_action :require_login

  def index
    @follows = current_user.follows_where_following
  end

  def destroy
    follow = Follow.find params[:id]
    follow.delete if follow.follower == current_user
    redirect_to people_path
  end

  def create
    guide = User.find_by slug: params[:user_id]
    follow = Follow.new(follower: current_user, guide: guide)
    follow.save if current_user.can_follow? guide
    redirect_to people_path
  end
end
