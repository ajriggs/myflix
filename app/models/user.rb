class User < ActiveRecord::Base
  include Sluggable
  has_secure_password validations: false

  before_save :render_unique_slug!

  validates :full_name, presence: true
  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, on: :create

  sluggable_column :username
end
