class QueueItem < ActiveRecord::Base
  include BelongsToUserable
  include BelongsToVideoable

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

  private

  def review
    @review ||= Review.find_by user: user, video: video
  end
end
