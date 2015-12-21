require 'spec_helper'
require 'shoulda-matchers'

# this version of the method always makes vids one by one, as if each is a day older than the next created.  Refactor if more flexibility is required down the line.
def assign_videos_to_category(count, category)
  count.times do |n|
    Fabricate :video, category: category, created_at: n.days.ago
  end
end

describe Category do
  it { should have_many(:videos).order 'created_at DESC' }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should validate_length_of(:name).is_at_least 3 }
end

describe '#recent_videos' do
  let(:comedy) { Fabricate :category, name: 'Comedy' }

  it 'returns an array of videos, sorted from newest to oldest by created_at' do
    assign_videos_to_category 3, comedy
    recent = comedy.recent_videos
    expect(recent[0].created_at > recent[2].created_at).to be true
  end
  it 'returns six videos if there are more than six within the category' do
    assign_videos_to_category 7, comedy
    expect(comedy.recent_videos.size).to eq 6
  end
  it 'returns all videos in the category, if fewer than six exist' do
    assign_videos_to_category 1, comedy
    expect(comedy.recent_videos.size).to eq 1
  end
  it 'returns an emtpy array if the category has no videos' do
    expect(comedy.videos).to eq []
  end
end
