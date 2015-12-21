require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_uniqueness_of(:video_id).scoped_to :user_id }
end

describe '#rating' do
  let(:item) { Fabricate :queue_item }

  it 'returns the rating for the video, as submitted by the current user' do
    user_review = Fabricate :review, user: item.user, video: item.video
    expect(item.rating).to eq user_review.rating
  end

  it 'returns nil if no rating is present' do
    expect(item.rating).to be nil
  end
end

describe '#category' do
  it "returns the item's video's category" do
    item = Fabricate :queue_item
    expect(item.category).to eq item.video.category
  end
end
