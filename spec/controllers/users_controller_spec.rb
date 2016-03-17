require 'spec_helper'

describe UsersController do
  it { should use_before_action :require_logout }

  describe 'GET new' do
    it 'sets @user as a new instance of User class' do
      get :new
      expect(assigns :user).to be_a_new User
    end
  end

  describe 'POST create' do
    let(:user_params) { Fabricate.attributes_for :user }

    context 'always' do
      it 'sets @user based on user params' do
        post :create, user: user_params
        expect(assigns(:user).full_name).to eq user_params[:full_name]
      end
    end

    context 'with valid input' do
      before { post :create, user: user_params }

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
      before { post :create, user: {email: '', full_name: '', password:''} }

      it 'does not save @user to the database' do
        expect(User.count).to eq 0
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end
    end

    context 'when sending emails' do
      before { post :create, user: user_params }

      it 'sends an email with valid input' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'sends to the newly registered user' do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq [user_params[:email]]
      end

      it 'sends the welcome message' do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include "Welcome to Myflix, #{user_params[:full_name]}"
      end

      it 'does not send an email with invalid controller input' do
        outbound_queue_count = ActionMailer::Base.deliveries.count
        post :create, user: {email: '', full_name: '', password:''}
        expect(ActionMailer::Base.deliveries.count).to eq outbound_queue_count
      end
    end
  end

  describe 'GET show' do
    it 'sets @user to the user defined by params[:id]' do
      user = Fabricate :user
      test_login user
      get :show, id: user.slug
      expect(assigns :user).to eq user
    end
  end
end
