class VideosController < ApplicationController

  def index
    @videos = Video.all.limit 6
    render :home
  end

  def show
    @video = Video.find_by(slug: params[:id])
  end

  

end
