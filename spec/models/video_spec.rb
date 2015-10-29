require 'spec_helper'
require 'shoulda-matchers'

def fabricate_video_add_ratings(array_of_ratings)
  Fabricate(:video) do
    reviews do
      #array should contain n elements of integer value, only 1..5
      array_of_ratings.map {|r| Fabricate(:review, rating: r, user: Fabricate(:user))}
    end
  end
end

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:tagline) }
end

describe '#search_by_title' do
  it 'returns an empty array if there are no matches' do
    south_park = Video.create(title: 'South Park', tagline: 'Kick da babyy!!')
    expect(Video.search_by_title('puppies')).to eq([])
  end

  it 'returns an empty array if supplied an empty string' do
    south_park = Video.create(title: 'South Park', tagline: 'Kick da babyy!!')
    expect(Video.search_by_title('')).to eq([])
  end

  it 'returns an array of the matched object, if there is 1 exact match' do
    south_park = Video.create(title: 'South Park', tagline: 'Kick da babyy!!')
    parks_and_rec = Video.create(title: 'Parks and Recreation', tagline: 'this show was kinda funny sometimes')
    expect(Video.search_by_title('South')).to eq([south_park])
  end

  it 'returns an array of the matched object, if there is 1 partial match' do
    south_park = Video.create(title: 'South Park', tagline: 'Kick da babyy!!')
    parks_and_rec = Video.create(title: 'Parks and Recreation', tagline: 'this show was kinda funny sometimes')
    expect(Video.search_by_title('South')).to eq([south_park])
  end

  it 'returns an array of all objects that  match, ordered by created_at' do
    south_park = Video.create(title: 'South Park', tagline: 'Kick da babyy!!', created_at: 1.day.ago)
    parks_and_rec = Video.create(title: 'Parks and Recreation', tagline: 'this show was kinda funny sometimes')
    expect(Video.search_by_title('Park')).to eq([parks_and_rec, south_park])
  end

  it 'is not case-sensitive' do
    south_park = Video.create(title: 'South Park', tagline: 'Kick da babyy!!')
    expect(Video.search_by_title('south park')).to eq([south_park])
  end
end

describe '#average_rating' do
  let(:video) { fabricate_video_add_ratings([1, 3, 5])
   }
  it "returns the string 'No Ratings' if no reviews have been submitted" do
    expect(Fabricate(:video).average_rating).to eq("No Ratings")
  end

  it 'returns the average as a float' do
    expect(video.average_rating).to be_a Float
  end

  it 'returns 3.0 if given a 1-star, a 3-star and a 5-star rating' do
    expect(video.average_rating).to eq(3.0)
  end

  it 'returns 3.5 if given a 3-star and a 4-star rating' do
    expect(fabricate_video_add_ratings([3, 4]).average_rating).to eq(3.5)
  end

end
