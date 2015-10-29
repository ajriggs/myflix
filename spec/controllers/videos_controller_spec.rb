require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe VideosController do
  it { should use_before_action :require_login }

  describe 'GET index' do
    it 'sets @categories to display all categories in the db' do
      Fabricate(:category) { videos count: 2 }
      test_login
      get :index
      expect(assigns :categories).to eq Category.all
    end
  end

  describe 'GET show' do
    let(:video) { Fabricate :video }

    before do
      test_login
      #the web call below requires an 'id', but I pass a slug into this field by overriding to_param w/ the sluggable gem that I made in course 2.
      get :show, id: video.slug
    end

    it 'sets @video to the specified video' do
      expect(assigns :video).to eq video
    end

    it 'associates @review to @video' do
      expect(assigns(:review).video_id).to eq video.id
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate :video }

    it 'sets @search_results based on submitted search' do
      test_login
      get :search, user_search: video.title
      expect(assigns :search_results).to include video
    end
  end
end
