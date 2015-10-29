module ApplicationHelper
  def display_avg_video_stars(video)
    video.average_rating.nan? ? 'No Ratings' : video.average_rating
  end
end
