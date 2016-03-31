class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new video_params
    if @video.save
      flash[:notice] = "#{@video.title} was successfully saved."
      redirect_to new_admin_video_path
    else
      flash[:error] = "Your submission contains validation errors. Please revise and resubmit."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :tagline, :category_id, :small_cover, :large_cover)
  end
end