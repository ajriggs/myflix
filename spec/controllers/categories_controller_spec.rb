require 'spec_helper'
require 'shoulda-matchers'

describe CategoriesController do
  describe 'GET show' do
    #the action below requires an 'id', but I pass a slug into this field by overriding to_param w/ the sluggable gem that I made in course 2.
    it_behaves_like 'ApplicationController#require_login' do
      let(:action) { get :show, id: Fabricate(:category) }
    end

    it 'sets @category' do
      test_login
      get :show, id: Fabricate(:category).slug
      expect(assigns :category).to be_a Category
    end
  end
end
