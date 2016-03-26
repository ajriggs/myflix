require 'spec_helper'
require 'shoulda-matchers'

describe QueueItem do
  it { should validate_uniqueness_of(:video_id).scoped_to :user_id }

  it { should belong_to :video }

  it_behaves_like 'BelongsToUserable' do
    let(:object) { Fabricate :queue_item }
  end

  it_behaves_like 'BelongsToVideoable' do
    let(:object) { Fabricate :queue_item }
  end

  describe '#rating=' do
    let(:item) { Fabricate :queue_item }

    it 'sets the rating for an existing video review, using the assigned value' do
      user_review = Fabricate :review, user: item.user, video: item.video, rating: 5
      item.rating = 1
      expect(Review.first.rating).to eq 1
    end

    it 'clears the rating for an existing video review, if given a nil' do
      user_review = Fabricate :review, user: item.user, video: item.video, rating: 5
      item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it 'clears the rating for an existing video review, if given an empty string' do
      user_review = Fabricate :review, user: item.user, video: item.video, rating: 5
      item.rating = ''
      expect(Review.first.rating).to be_nil
    end

    it 'creates a new review using the assigned rating, if no review already exists' do
      item.rating = 1
      expect(Review.first.rating).to eq 1
    end
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
end
