class Video < ActiveRecord::Base
  include Sluggable

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates :title, presence: true, uniqueness: true
  validates :tagline, presence: true, length: { minimum: 10  }

  sluggable_column :title

  def self.search_by_title(search)
    return [] if search.blank?
    where("title ILIKE ?", "%#{search}%").order 'created_at DESC'
  end

  def average_rating
    # returns NaN by default, if no ratings have been given. This case is handled as a display level concern in helpers.
    reviews.reload
    stars_given = reviews.inject(0) { |total, review| total + review.rating }
    (stars_given.to_f / reviews.count.to_f).round 1
  end
end
