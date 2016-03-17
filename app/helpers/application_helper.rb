module ApplicationHelper
  def display_avg_video_stars(video)
    video.average_rating.nan? ? 'No Ratings' : video.average_rating
  end

  def rating_choices(selected=nil)
    options_for_select((1..5).map { |n| [pluralize(n, 'Star'), n] }, selected)
  end

  def gravatar_image_string(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end
end
