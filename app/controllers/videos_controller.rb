class VideosController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.all
    render :home
  end

  def show
    @video = Video.find_by(slug: params[:id])
  end

  def search
    @search_results = Video.search_by_title(params[:user_search])
  end

end
