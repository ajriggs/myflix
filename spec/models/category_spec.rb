require 'spec_helper'
require 'shoulda-matchers'

# creates random seed parameters for an instance of class Video, except for category association

describe Category do
  it { should have_many(:videos).order('title') }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
