require 'spec_helper'

describe ApplicationController do
  controller do
    before_action :require_login, only: [:require_login_test]
    before_action :require_logout, only: [:require_logout_test]

    def require_login_test
      @redirect_bypassed = true
      render nothing: true
    end

    def require_logout_test
      @redirect_bypassed = true
      render nothing: true
    end
  end

  describe '#require_login' do
    before do
      routes.draw {get 'require_login_test' => 'anonymous#require_login_test'}
    end

    context 'with a valid session' do
      before do
        test_login
        get :require_login_test
      end

      it 'does not redirect' do
        expect(assigns :redirect_bypassed).to be true
      end

      it 'does not set flash[:notice]' do
        expect(flash[:notice]).to be nil
      end
    end

    context 'without a valid session' do
      before { get :require_login_test }

      it 'redirects to the login page' do
        expect(response).to redirect_to login_path
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_a String
      end
    end
  end

  describe '#require_logout' do
    before do
      routes.draw {get 'require_logout_test' => 'anonymous#require_logout_test'}
    end

    context 'with a valid session' do
      before do
        test_login
        get :require_logout_test
      end

      it 'redirects to the home page' do
        expect(response).to redirect_to home_path
      end

      it 'sets an error message in flash[:notice] if a user is logged in' do
        expect(flash[:notice]).to be_a String
      end
    end

    context 'without a valid session' do
      before { get :require_logout_test }

      it 'does not redirect' do
        expect(assigns :redirect_bypassed).to be true
      end

      it 'does not set flash[:notice]' do
        expect(flash[:notice]).to be nil
      end
    end
  end

  describe '#logged_in?' do
    it 'returns true if session user_id is set' do
      test_login
      expect(controller.logged_in?).to be true
    end

    it 'returns false if session user_id is not set' do
      expect(controller.logged_in?).to be false
    end
  end

  describe '#current_user' do
    let(:user_id) { test_login }
    before { user_id }

    it 'returns the logged in user, if a user is logged in' do
      expect(controller.current_user.id).to eq user_id
    end

    it 'returns nil if not logged in' do
      test_logout
      expect(controller.current_user).to be nil
    end
  end
end
