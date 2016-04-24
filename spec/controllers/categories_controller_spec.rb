require 'spec_helper'
require 'shoulda-matchers'

describe CategoriesController do
  describe 'GET show' do
    it_behaves_like 'user can only access if logged in' do
      let(:action) { get :show, id: Fabricate(:category).slug }
    end

    it 'sets @category' do
      test_login
      get :show, id: Fabricate(:category).slug
      expect(assigns :category).to be_a Category
    end
  end
end
