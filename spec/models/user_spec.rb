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
