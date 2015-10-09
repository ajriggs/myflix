require 'spec_helper'

# creates random seed parameters for an instance of class Video, except for category association

describe Category do
  it 'saves itself' do
    comedy = Category.new(name: 'Comedy')
    comedy.save
    expect(Category.first).to eq(comedy)
  end

  it 'has many videos, ordered by title' do
    comedy = Category.new(name: 'Comedy')
    2.times { comedy.videos.build(title: rand, tagline: rand) }
    expect(comedy.videos.first.title < comedy.videos.last.title)

    # or, alternatively:
    # scrubs = Video.create(title: 'scrubs', tagline: 'JD: "...Jambalaya!!"', category: comedy)
    # south_park = Video.create(title: 'south park', tagline: 'Kyle: "kick the baby!"', category: comedy)
    # expect(comedy.videos).to eq([scrubs, south_park])
  end

end
