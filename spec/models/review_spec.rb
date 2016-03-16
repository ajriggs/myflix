require 'spec_helper'
require 'shoulda-matchers'

describe Review do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :rating }
  it { should validate_uniqueness_of(:user_id).scoped_to :video_id }
  it { should validate_length_of(:review).is_at_least 10  }
end
