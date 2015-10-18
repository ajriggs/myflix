require 'spec_helper'
require 'shoulda-matchers'

describe User do
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
end
