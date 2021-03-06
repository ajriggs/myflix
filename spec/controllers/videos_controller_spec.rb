require 'spec_helper'
require 'shoulda-matchers'

describe VideosController do

  describe 'GET index' do
    it_behaves_like 'user can only access if logged in' do
      let(:action) { get :index }
    end

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
      get :show, id: video.slug
    end

    it_behaves_like 'user can only access if logged in' do
      let(:action) { get :show, id: video }
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

    it_behaves_like 'user can only access if logged in' do
      let(:action) { get :search, user_search: video.title }
    end

    it 'sets @search_results based on submitted search' do
      test_login
      get :search, user_search: video.title
      expect(assigns :search_results).to include video
    end
  end
end
