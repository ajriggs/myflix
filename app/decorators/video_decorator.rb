class VideoDecorator < Draper::Decorator
  delegate_all

  def rating_string
    video.average_rating.nan? ? 'No Ratings' : video.average_rating
  end
end
