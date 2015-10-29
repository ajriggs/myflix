class Video < ActiveRecord::Base
  include Sluggable

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates :title, presence: true, uniqueness: true
  validates :tagline, presence: true, length: {minimum: 10  }

  sluggable_column :title

  def self.search_by_title(search)
    return [] if search.blank?
    where("lower(title) LIKE ?", "%#{search.downcase}%").order('created_at DESC')
  end

  def average_rating
    reviews.reload
    return 'No Ratings' if reviews.empty?
    stars_given = 0
    reviews.each { |review| stars_given += review.rating }
    (stars_given.to_f / reviews.count.to_f).round(1)
  end
end
