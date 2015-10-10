class VideosController < ApplicationController

  def index
    @categories = Category.all
    render :home
  end

  def show
    @video = Video.find_by(slug: params[:id])
  end

  def search
    @search_results = Video.search_by_title(params[:search])
  end

end
