require 'spec_helper'

shared_examples 'Reviewable' do
  it { should have_many(:reviews).order 'created_at DESC' }

  describe '#review_count' do
    it 'returns the number of reviews owned by the scoped object' do
      expect(object.review_count).to eq object.reviews.count
    end
  end
end

shared_examples 'BelongsToUserable' do
  it { should belong_to :user }

  describe '#user_name' do
    it 'returns the name of the owning user' do
      expect(object.user_name).to eq User.last.full_name
    end
  end
end

shared_examples 'BelongsToVideoable' do
  it { should belong_to :video }

  describe '#video_title' do
    it 'should return the title of the owning video' do
      expect(object.video_title).to eq Video.first.title
    end
  end

  describe '#category' do
    it "returns the category of the owning video" do
      expect(object.category).to eq Video.first.category
    end
  end

  describe '#category_name' do
    it "it returns the category name of the owning video" do
      expect(object.category_name).to eq Video.first.category.name
    end
  end
end
