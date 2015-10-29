class ReviewsController < ApplicationController
  before_action :require_login

  def create
    @video = Video.find_by(slug: params[:video_id])
    @review = @video.reviews.new(review_params.merge!(user: current_user))
    if @review.save
      redirect_to video_path(@video), notice: 'Review saved.'
    else
      flash.now[:error] = 'Something is wrong with your submission.'
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :review)
  end
end
