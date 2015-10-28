require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe VideosController do

  describe 'GET index' do
    it { should use_before_action :require_login }

    it 'sets @categories for authenticated users' do
      test_login
      category = Fabricate(:category) { videos(count: 2) }
      get :index
      expect(assigns(:categories)).to eq Category.all
    end
  end

  describe 'GET show' do
    it { should use_before_action :require_login }

    it 'sets @video for authenticated users' do
      test_login
      video = Fabricate(:video)
      #the web call below requires an 'id', but I pass a slug into this field by overriding to_param w/ the sluggable gem i made in course 2.
      get :show, id: video.slug
      expect(assigns(:video)).to eq video
    end
  end

  describe 'GET search' do
    it { should use_before_action :require_login }

    it 'sets @search_results for authenticated users' do
      test_login
      video = Fabricate(:video)
      get :search, user_search: video.title
      expect(assigns(:search_results)).to include video
    end
  end
end
