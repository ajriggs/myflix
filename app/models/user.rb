class User < ActiveRecord::Base
  include Reviewable
  include Sluggable

  sluggable_column :email
  before_create :render_unique_slug!

  has_secure_password validations: false

  has_many :follows_where_follower, class_name: 'Follow', foreign_key: 'guide_id'
  has_many :follows_where_following, class_name: 'Follow', foreign_key: 'follower_id'

  has_many :queue_items, -> { order('position ASC') }

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  def render_token!
    update_attribute :token, SecureRandom.urlsafe_base64.downcase
  end

  def clear_token!
    update_attribute :token, nil
  end

  def followers
    follows_where_follower.map(&:follower)
  end

  def guides
    follows_where_following.map(&:guide)
  end

  def following?(user)
    follows_where_following.map(&:guide).include? user
  end

  def can_follow?(user)
    !(following?(user) || user == self)
  end

  def follow!(user)
    Follow.create follower: self, guide: user
  end

  def next_position_in_queue
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

  def queue_size
    queue_items.count
  end
end
