class User < ActiveRecord::Base
  include Sluggable
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> { order('position ASC') }

  before_save :render_unique_slug!

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  sluggable_column :email

  def next_slot_in_queue
    queue_items.count + 1
  end

  def remove_from_queue!(queue_item)
    if queue_items.include? queue_item
      queue_items.each do |i|
        i.update_attribute :position, i.position - 1 if i.position > queue_item.position
      end
      queue_item.destroy
    end
  end
end
