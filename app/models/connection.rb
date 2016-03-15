class Connection < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :guide, class_name: 'User'

  validates_uniqueness_of :follower_id, scope: :guide_id

  def guide_name
    guide.full_name
  end

  def guide_queue_size
    guide.queue_items.count
  end

  def guide_followers_count
    guide.followers.count
  end
end
