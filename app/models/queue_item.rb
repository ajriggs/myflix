class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video_id, scope: :user_id

  def rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end

  def category
    video.category
  end

  def next_slot_in_queue
    user.queue_items.count + 1
  end
end
