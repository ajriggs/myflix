require 'spec_helper'
require 'shoulda-matchers'

describe User do
  it { should have_many :reviews }
  it { should have_many :queue_items }
  it { should have_many(:follows_where_follower).class_name('Follow').with_foreign_key 'guide_id' }
  it { should have_many(:follows_where_following).class_name('Follow').with_foreign_key 'follower_id' }
  it { should validate_presence_of(:password).on :create }
  it { should validate_length_of(:password).is_at_least 6 }
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }

  describe '#render_token!' do
    let(:riggs) { Fabricate :user }
    before { riggs.render_token! }

    it 'sets [user].token as a 22-character string (to be emailed to a user who needs a password reset)' do
      expect(riggs.token.length).to eq 22
    end

    it 'generates a URL-safe string' do
      expect(riggs.token.parameterize).to eq riggs.token
    end

    it 'genereate a a string with only lower-case letter characters' do
      expect(riggs.token.downcase).to eq riggs.token
    end
  end

  describe '#clear_token!' do
    let(:riggs) { Fabricate :user }

    it "sets the user's token attribute to nil (clears the db column) if the user has a token set" do
      riggs.render_token!
      riggs.clear_token!
      expect(riggs.token).to eq nil
    end

    it "sets the user's token attribute to nil if the user does not have a token set" do
      riggs.clear_token!
      expect(riggs.token).to eq nil
    end
  end

  describe '#followers' do
    let(:riggs) { Fabricate :user, full_name: 'Riggs' }

    it 'returns an array of users following the scoped user' do
      3.times { Fabricate :follow, guide: riggs }
      expect(riggs.followers.count).to eq 3
    end

    it 'returns an empty array if the user has no followers' do
      expect(riggs.followers).to eq []
    end

    it 'does not include users followed by the scoped user' do
      1.times { Fabricate :follow, follower: riggs }
      1.times { Fabricate :follow, guide: riggs }
      expect(riggs.followers.count).to eq 1
    end
  end

  describe '#guides' do
    let (:riggs) { Fabricate :user, full_name: 'Riggs' }

    it 'returns an array of all users followed by the scoped user' do
      3.times { Fabricate :follow, follower: riggs }
      expect(riggs.guides.count).to eq 3
    end

    it 'returns an empty array if scoped user is not following anyone' do
      expect(riggs.guides).to eq []
    end

    it 'does not include users following the scoped user' do
      1.times { Fabricate :follow, follower: riggs }
      1.times { Fabricate :follow, guide: riggs }
      expect(riggs.guides.count).to eq 1
    end
  end

  describe '#following?' do
    let(:riggs) { Fabricate :user, full_name: 'Riggs' }
    let(:james) { Fabricate :user, full_name: 'James' }
    let!(:follow) { Fabricate :follow, follower: riggs, guide: james }

    it 'returns true if the user is following the provided guide' do
      expect(riggs.following? james).to be true
    end

    it 'returns false if the user is not following the provided guide' do
      expect(james.following? riggs).to be false
    end
  end

  describe '#can_follow?' do
    let(:riggs) { Fabricate :user }
    let(:james) { Fabricate :user }

    it 'returns false if the provided user is also the current/scoped user' do
      expect(james.can_follow? james).to be false
    end

    it 'returns false if the provided user is already followed by the current/scoped user' do
      Fabricate :follow, follower: riggs, guide: james
      expect(riggs.can_follow? james).to be false
    end

    it 'returns true if provided a user other than the scoped user, who has not already been followed by the scoped user' do
      expect(riggs.can_follow? james).to be true
    end
  end

  describe '#next_slot_in_queue' do
    let(:user) { Fabricate :user }

    it "returns one greater than the position of the user's last queue item" do
      3.times { |n| Fabricate :queue_item, user: user, position: n + 1 }
      expect(user.next_slot_in_queue).to eq 4
    end

    it "returns 1 if there are no other videos in the user's queue" do
      expect(user.next_slot_in_queue).to eq 1
    end
  end

  describe '#remove_from_queue!' do
    let(:user) { Fabricate :user }

    it 'deletes the input queue item, if it belongs to the current user' do
      item_to_delete = Fabricate :queue_item, user: user
      user.remove_from_queue!(item_to_delete)
      expect(QueueItem.all.count).to eq 0
    end

    it 'does not delete the queue item, if it does not belong to current user' do
      item_to_delete = Fabricate :queue_item
      user.remove_from_queue!(item_to_delete)
      expect(QueueItem.all.count).to eq 1
    end
  end

  describe '#has_in_queue?' do
    let(:user) { Fabricate :user }
    let(:south_park) { Fabricate :video, title: 'South Park', tagline: 'hahahaha so so funny!' }

    it "returns true if the given video is in the user's queue" do
      Fabricate :queue_item, video: south_park, user: user
      expect(user.has_in_queue? south_park).to be true
    end

    it "returns false if the given video is not in the user's queue" do
      expect(user.has_in_queue? south_park).to be false
    end
  end

  describe '#update_queue!' do
    let(:user) { Fabricate :user }
    let!(:queue_item_1) { Fabricate :queue_item, user: user, position: 1, rating: 2 }
    let!(:queue_item_2) { Fabricate :queue_item, user: user, position: 2, rating: 5 }
    let!(:queue_item_3) { Fabricate :queue_item, user: user, position: 3, rating: nil }
    let!(:queue) { [queue_item_1, queue_item_2, queue_item_3] }

    it 'does not update the queue if any item submitted for update is not associated with the user' do
      invalid_queue = queue << Fabricate(:queue_item)
      invalid_queue_params = render_queue_params invalid_queue
      user.update_queue! invalid_queue_params
      expect(user.queue_items).to match_array queue[0...-1]
    end

    it 'updates the queue if user provides first rating for a queue item' do
      queue << Fabricate(:queue_item, user: user, rating: nil)
      new_queue = queue.clone
      new_queue[3].rating = 5
      queue_params_with_new_rating = render_queue_params new_queue
      user.update_queue!(queue_params_with_new_rating)
      expect(user.queue_items).to match_array new_queue
    end

    it 'updates the ratings and positions of all items in the queue with any changes submitted by the user' do
      queue_params = render_queue_params queue
      queue_params[0][:position] = 2
      queue_params[0][:rating] = 1
      queue_params[1][:position] = 1
      queue_params[1][:rating] = nil
      user.update_queue!(queue_params)
      expect(render_queue_params user.queue_items).to match_array queue_params
    end

    it 'does not modify ratings or positions if the same values are input' do
      user.update_queue!(render_queue_params queue)
      expect(user.queue_items).to match_array queue
    end

    it 'updates queue item positions even if some positions are not unique' do
      queue_params = render_queue_params queue
      queue_params[0][:position] = 2
      queue_params[1][:position] = 2
      user.update_queue!(queue_params)
      expect(render_queue_params user.queue_items).to match_array queue_params
    end

    it 'does not update the queue if any positions are provided as non-integers' do
      queue_params = render_queue_params queue
      queue_params[0][:position] = 2.0
      queue_params[1][:position] = 1.0
      user.update_queue!(queue_params) rescue ActiveRecord::RecordInvalid
      expect(user.queue_items).to match_array queue
    end
  end

  describe '#normalize_queue!' do
    let(:user) { Fabricate :user }
    let(:queue_item_1) { Fabricate :queue_item, user: user, position: 1, rating: 2 }
    let(:queue_item_2) { Fabricate :queue_item, user: user, position: 2, rating: 5 }
    let(:queue_item_3) { Fabricate :queue_item, user: user, position: 3, rating: nil }
    let!(:queue) { [queue_item_1, queue_item_2, queue_item_3] }

    it 'does not alter the order of the queue, if all queue item positions are unique non-zero numbers' do
      user.normalize_queue!
      expect(user.queue_items).to eq queue
    end

    it 'indexes the queue beginning with 1, if the queue is not already 1-indexed' do
      user.queue_items.each { |item| item.position -= 1 }
      user.normalize_queue!
      expect(user.queue_items.map &:position).to eq [1, 2, 3]
    end

    it 'it indexes the queue if duplicate positions are entered' do
      user.queue_items[0].position = 2
      user.queue_items[2].position = 2
      user.normalize_queue!
      expect(user.queue_items.map &:position).to eq [1, 2, 3]
    end
  end

  def render_queue_params(queue=nil)
    queue_params = queue.map do |item|
      { id: item.id, position: item.position, rating: item.rating }
    end
  end
end
