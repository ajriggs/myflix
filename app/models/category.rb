class Category < ActiveRecord::Base
  include Sluggable

  has_many :videos, -> { order('title') }

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}

  sluggable_column :name
end
