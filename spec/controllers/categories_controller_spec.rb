require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe CategoriesController do
  it { should use_before_action :require_login }

  describe 'GET show' do
    before do
      test_login
      #the web call below requires an 'id', but I pass a slug into this field by overriding to_param w/ the sluggable gem that I made in course 2.
      get :show, id: Fabricate(:category).slug
    end

    it 'sets @category' do
      expect(assigns :category).to be_a Category
    end
  end
end
