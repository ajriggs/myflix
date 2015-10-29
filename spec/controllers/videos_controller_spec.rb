require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe VideosController do
  it { should use_before_action :require_login }

  describe 'GET index' do
    it 'sets @categories' do
      test_login
      category = Fabricate(:category) { videos(count: 2) }
      get :index
      expect(assigns(:categories)).to eq Category.all
    end
  end

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    before do
      test_login
      #the web call below requires an 'id', but I pass a slug into this field by overriding to_param w/ the sluggable gem i made in course 2.
      get :show, id: video.slug
    end

    it 'sets @video' do
      expect(assigns(:video)).to eq video
    end

    it 'sets @review' do
      expect(assigns(:review)).to be_a_new Review
    end
  end

  describe 'GET search' do
    it 'sets @search_results' do
      test_login
      video = Fabricate(:video)
      get :search, user_search: video.title
      expect(assigns(:search_results)).to include video
    end
  end
end
