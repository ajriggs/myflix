module BelongsToVideoable
  extend ActiveSupport::Concern
  
  included do
    belongs_to :video
  end

  def video_title
    video.title
  end

  def category
    video.category
  end

  def category_name
    video.category.name
  end
end
