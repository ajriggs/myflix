require 'spec_helper'

describe Connection do
  it { should belong_to(:guide).class_name 'User' }
  it { should belong_to(:follower).class_name 'User' }
end

describe '#guide_name' do
  it 'returns the name of the guide in a social connection' do
    guide = Fabricate :user
    connection = Fabricate :connection, guide: guide
    expect(connection.guide_name).to eq guide.full_name
  end

  describe '#guide_queue_size' do
    let(:guide) { Fabricate :user }
    let(:connection) { Fabricate :connection, guide: guide }

    it "returns the number of video items in the guide's queue" do
      3.times { Fabricate :queue_item, user: guide }
      expect(connection.guide_queue_size).to eq 3
    end

    it 'returns the integer 0 if the guide has no videos queued' do
      expect(connection.guide_queue_size).to eq 0
    end
  end

  describe '#guide_followers_count' do
    let(:guide) { Fabricate :user }

    it "returns the number of people following the guide of a connection" do
      3.times { Fabricate :connection, guide: guide }
      expect(Connection.first.guide_followers_count).to eq 3
    end

    it 'returns 1 if the scoped connection is the only connection with the current guide' do
      Fabricate :connection, guide: guide
      expect(Connection.first.guide_followers_count).to eq 1
    end
  end
end
