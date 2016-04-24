require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it_behaves_like 'user can only access if logged out' do
      let(:action) { get :new }
    end

    it 'sets @user as a new instance of User class' do
      get :new
      expect(assigns :user).to be_a_new User
    end

    context 'with a valid invite token, passed through params[:token]' do
      let(:invite) { Fabricate :invitation }

      before { get :new, token: invite.token }

      it 'sets @invitation to the invite with the correct token' do
        expect(assigns(:invitation).token).to eq invite.token
      end
    end
  end

  describe 'POST create' do
    let(:user_params) { Fabricate.attributes_for :user }

    before do
      expect_any_instance_of(UserRegistration).to receive(:register).and_return registration
    end

    context 'with a successful registration' do
      let(:registration) { double :registration, successful?: true }

      before do
        expect(registration).to receive :handle_invite
        post :create, user: user_params
      end

      it 'sets @user based on the provided user params' do
        expect(assigns(:user).full_name).to eq user_params[:full_name]
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_present
      end

      it 'redirects to the login path' do
        expect(response).to redirect_to login_path
      end
    end

    context 'with an unsuccessful registration' do
      let(:registration) { double :registration, successful?: false, error_message: 'Your registration was unsuccessful.' }

      before { post :create, user: user_params }

      it 'sets @user based on the provided user params' do
        expect(assigns(:user).full_name).to eq user_params[:full_name]
      end

      it 'renders the registration template' do
        expect(response).to render_template :new
      end

      it "sets flash[:error] based on the regustration's error message" do
        expect(flash[:error]).to eq registration.error_message
      end
    end
  end

  describe 'GET show' do
    let(:user) { Fabricate :user }

    it_behaves_like 'user can only access if logged in' do
      let(:action) { get :show, id: user.slug }
    end

    it 'sets @user to the user defined by params[:id]' do
      test_login user
      get :show, id: user.slug
      expect(assigns :user).to eq user
    end
  end
end
