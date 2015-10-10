class Video < ActiveRecord::Base
  include Sluggable
  belongs_to :category

  validates :title, presence: true, uniqueness: true
  validates :tagline, presence: true, length: {minimum: 15}

  sluggable_column :title

  def self.search_by_title(search)
    return [] if search.blank?
    where("lower(title) LIKE ?", "%#{search.downcase}%").order('created_at DESC')
  end
end
