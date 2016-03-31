require 'spec_helper'

describe AdminsController do
  it { should use_before_filter :require_admin }

  controller do
    before_action :require_admin

    def require_admin_test
      @redirect_bypassed = true
      render nothing: true
    end
  end

  describe '#require_admin' do
    before do
      routes.draw { get 'require_admin_test' => 'anonymous#require_admin_test' }
    end

    context 'when logged in as admin' do
      let(:admin) { Fabricate :user, admin: true }

      before do
        test_login admin
        get :require_admin_test
      end

      it 'does not redirect the user' do
        expect(assigns :redirect_bypassed).to be true
      end

      it 'does not set flash[:error]' do
        expect(flash[:error]).to_not be_present
      end
    end

    context 'when logged in as non-admin' do
      let(:user) { Fabricate :user }

      before do
        test_login user
        get :require_admin_test
      end

      it 'redirects to the home path' do
        expect(response).to redirect_to home_path
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end
    end

    context 'when not logged in' do
      before { get :require_admin_test }

      it 'redirects to the home path' do
        expect(response).to redirect_to home_path
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end
    end
  end
end
