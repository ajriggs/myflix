class Review <ActiveRecord::Base
  include BelongsToUserable
  include BelongsToVideoable

  validates :rating, presence: true, numericality: { greater_than: 0, less_than: 6 }
  validates :review, presence: true, length: { minimum: 10 }
  validates_uniqueness_of :user_id, scope: :video_id
end
