require 'spec_helper'
require 'shoulda-matchers'

describe User do
  it { should have_many :reviews }
  it { should have_many :queue_items }
  it { should validate_presence_of(:password).on :create }
  it { should validate_length_of(:password).is_at_least 6 }
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
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
    expect(user.has_in_queue? south_park).to be nil
  end
end

describe '#update_queue!' do
  let(:user) { Fabricate :user }
  let!(:queue) { render_queue(user, 3) }

  it 'does not update the queue if any item submitted for update is not associated with the user' do
    invalid_queue = queue << Fabricate(:queue_item)
    invalid_queue_params = render_queue_params invalid_queue
    user.update_queue! invalid_queue_params
    queue.pop
    expect(user.queue_items).to match_array queue
  end

  it 'updates the queue if user provides first rating for a queue item' do
    queue << Fabricate(:queue_item, user: user, rating: nil)
    new_queue = queue.clone
    new_queue[3].rating = 5
    user.update_queue!(render_queue_params new_queue)
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
    user.update_queue!(queue_params) rescue
    expect(user.queue_items).to match_array queue
  end
end

describe '#normalize_queue!' do
  let(:user) { Fabricate :user }
  let!(:queue) { render_queue(user, 3) }

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
