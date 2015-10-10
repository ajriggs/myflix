require 'spec_helper'

describe Video do
  it 'saves itself' do
    video = Video.new(title: 'spec', tagline: 'this is a spec tag')
    video.save
    expect(Video.first).to eq(video)
  end

  it 'belongs to one category' do
    comedy = Category.new(name: 'Comedy', id: 1)
    south_park = Video.new(title: 'south park', tagline: 'Kyle: "kick the baby!"', category: comedy)
    expect(south_park.category).to eq(comedy)
  end

  it 'has a unique title' do
    south_park = Video.create(title: 'south park', tagline: 'Kyle: "kick the baby!"')
    duplicate = Video.new(title: 'south park', tagline: 'Kyle: "kick the baby!"')
    expect(duplicate.save).to eq(false) # because title is already taken
    no_title = Video.new(tagline: 'Kyle: "kick the baby!"')
    expect(no_title.save).to eq(false)
  end

  it 'has a tagline of 15 characters minimum' do
    no_tagline = Video.new(title: 'south park')
    expect(no_tagline.save).to eq(false)
    south_park = Video.new(title: 'south park', tagline: 'Kick the baby!')
    expect(south_park.save).to eq(false) # because tagline is 14 chars, not 15
  end

end
