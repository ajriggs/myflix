class Video < ActiveRecord::Base
  include Sluggable
  belongs_to :category

  validates :title, presence: true, uniqueness: true
  validates :tagline, presence: true, length: {minimum: 15}

  sluggable_column :title
end
