require 'spec_helper'
require 'shoulda-matchers'

describe Review do
  it { should validate_presence_of :rating }
  it { should validate_uniqueness_of(:user_id).scoped_to :video_id }
  it { should validate_length_of(:review).is_at_least 10 }

  it { should belong_to :video }

  it_behaves_like 'BelongsToUserable' do
    let(:object) { Fabricate(:review, user: Fabricate(:user)) }
  end

  it_behaves_like 'BelongsToVideoable' do
    let(:object) { Fabricate(:review, video: Fabricate(:video)) }
  end
end
