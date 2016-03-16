require 'spec_helper'

describe Follow do
  it { should belong_to(:guide).class_name 'User' }
  it { should belong_to(:follower).class_name 'User' }

  describe '#guide_name' do
    it 'returns the name of the guide in a social "follow"' do
      guide = Fabricate :user
      follow = Fabricate :follow, guide: guide
      expect(follow.guide_name).to eq guide.full_name
    end
  end

  describe '#guide_queue_size' do
    let(:guide) { Fabricate :user }
    let(:follow) { Fabricate :follow, guide: guide }

    it "returns the number of video items in the guide's queue" do
      3.times { Fabricate :queue_item, user: guide }
      expect(follow.guide_queue_size).to eq 3
    end

    it 'returns the integer 0 if the guide has no videos queued' do
      expect(follow.guide_queue_size).to eq 0
    end
  end

  describe '#guide_followers_count' do
    let(:guide) { Fabricate :user }

    it "returns the number of people following the guide of the scoped follow" do
      3.times { Fabricate :follow, guide: guide }
      expect(Follow.first.guide_followers_count).to eq 3
    end

    it 'returns 1 if the scoped follow is the only follow with the current guide' do
      Fabricate :follow, guide: guide
      expect(Follow.first.guide_followers_count).to eq 1
    end
  end
end
