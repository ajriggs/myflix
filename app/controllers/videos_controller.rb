class VideosController < ApplicationController
  before_action :require_login
  decorates_assigned :video

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find_by slug: params[:id]
    @review = @video.reviews.new
  end

  def search
    @search_results = Video.search_by_title params[:user_search]
  end
end
