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
    queue_item.destroy if queue_items.include? queue_item
  end

  def has_in_queue?(video)
    queue_items.pluck(:video_id).include? video.id
  end

  def update_queue!(queue_params)
    ActiveRecord::Base.transaction do
      queue_params.each_with_index do |params, index|
        queue_item = QueueItem.find params[:id]
        if queue_item.user == self
          queue_item.update_attributes! position: params[:position], rating: params[:rating]
        end
      end
    end
  end

  def normalize_queue!
    queue_items.each_with_index {|item, index| item.update! position: index + 1}
  end
end
