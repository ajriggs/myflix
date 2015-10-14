require 'spec_helper'
require 'shoulda-matchers'

def assign_videos_to_category(int, category)
  int.times do |n|
    Video.create(title: "video #{n}", tagline: "it's the tagline", category: category, created_at: n.days.ago)
  end
end

describe Category do
  it { should have_many(:videos).order('created_at DESC') }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end

describe '#recent_videos' do
  it 'returns an array of videos, sorted from newest to oldest by created_at' do
    comedy = Category.create(name: 'Comedy')
    assign_videos_to_category(3, comedy)
    recent = comedy.recent_videos
    expect(recent[0].created_at > recent[2].created_at).to eq(true)
  end
  it 'returns six videos if there are more than six within the category' do
    comedy = Category.create(name: 'Comedy')
    assign_videos_to_category(7, comedy)
    expect(comedy.recent_videos.size).to eq(6)
  end
  it 'returns all videos in the category, if fewer than six exist' do
    comedy = Category.create(name: 'Comedy')
    assign_videos_to_category(1, comedy)
    expect(comedy.recent_videos.size).to eq(1)
  end
  it 'returns an emtpy array if the category has no videos' do
    comedy = Category.create(name: 'Comedy')
    expect(comedy.videos).to eq([])
  end
end
