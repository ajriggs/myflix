class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, { only_integer: true }

  def rating
    review.rating if review
  end

  def rating=(rating)
    if review
      review.update_attribute :rating, rating unless rating == ''
      review.update_attribute :rating, nil if rating == ''
    else
      new_review = Review.new user: user, video: video
      rating == '' ? new_review.rating = nil : new_review.rating = rating
      new_review.save validate: false
    end
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

  private

  def review
    @review ||= Review.find_by user: user, video: video
  end
end
