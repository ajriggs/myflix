class Category < ActiveRecord::Base
  include Sluggable

  has_many :videos, -> { order('created_at DESC') }

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}

  sluggable_column :name

  def recent_videos
    videos.first 6
  end
end
