require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe CategoriesController do
  it { should use_before_action(:require_login) }

  describe 'GET show' do
    it 'sets @category' do
      test_login
      get :show, id: Fabricate(:category).slug
      expect(assigns(:category)).to be_a Category
    end
  end
end
