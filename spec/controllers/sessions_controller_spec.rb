require 'spec_helper'
require 'shoulda-matchers'

describe SessionsController do
  it { should use_before_action :require_logout }

  describe 'POST create' do
    let(:user) { Fabricate :user }

    context 'with valid credentials' do
      before { post :create, email: user.email, password: user.password }

      it 'sets the session user_id' do
        expect(session[:user_id]).to eq user.id
      end

      it 'redirects to the home page' do
        expect(response).to redirect_to home_path
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_a String
      end
    end

    context 'with invalid credentials' do
      before { post :create, email: user.email, password: user.password + '1' }

      it 'does not set the session user_id' do
        expect(session[:user_id]).to be nil
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'GET destroy' do
    before do
      test_login
      get :destroy
    end

    it 'sets the session user_id to nil' do
      expect(session[:user_id]).to be nil
    end

    it 'redirects to the front page' do
      expect(response).to redirect_to root_path
    end

    it 'sets flash[:notice]' do
      expect(flash[:notice]).to be_a String
    end
  end
end
