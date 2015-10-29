require 'spec_helper'

include Testable

describe UsersController do
  it { should use_before_action :require_logout }

  describe 'GET new' do
    it 'sets @user as a new instance of User class' do
      get :new
      expect(assigns(:user)).to be_a_new User
    end
  end

  describe 'POST create' do
    it 'sets @user' do
      post :create, user: { email: faker_email, password: 'password', full_name: faker_name }
      expect(assigns(:user)).to be_a User
    end

    context 'with valid input' do
      before do
        post :create, user: { email: faker_email, password: 'password', full_name: faker_name }
      end

      it 'saves @user to the database' do
        expect(User.count).to eq 1
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to login_path
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_a String
      end
    end

    context 'with invalid input' do
      before { post :create, user: {email: '', password: '', full_name: ''} }

      it 'does not save @user to the database' do
        expect(User.count).to eq 0
      end

      it 'renders the new template if input is invalid' do
        expect(response).to render_template :new
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_a String
      end
    end
  end
end
