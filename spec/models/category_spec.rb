require 'spec_helper'
require 'shoulda-matchers'

describe Category do
  it { should have_many(:videos).order('title') }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
