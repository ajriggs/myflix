require 'spec_helper'
require 'shoulda-matchers'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:tagline)}
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
