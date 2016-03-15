class Review <ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :rating, presence: true, numericality: { greater_than: 0, less_than: 6 }
  validates :review, presence: true, length: { minimum: 10 }
  validates_uniqueness_of :user_id, scope: :video_id

  def video_title
    video.title
  end

  def user_name
    user.full_name
  end
end
