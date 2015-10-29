require 'spec_helper'
require 'shoulda-matchers'

describe User do
  it { should have_many :reviews }
  it { should validate_presence_of(:password).on :create }
  it { should validate_length_of(:password).is_at_least 6 }
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
end
