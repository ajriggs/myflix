require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it_behaves_like 'ApplicationController#require_logout' do
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
    let(:user_params) { Fabricate.attributes_for(:user) }

    it_behaves_like 'ApplicationController#require_logout' do
      let(:action) {
        charge = double('charge')
        charge.stub(:successful?).and_return true
        StripeWrapper::Charge.stub(:create).and_return charge
        post :create, user: user_params
      }
    end

    it 'saves @user to the database' do
      charge = double('charge')
      charge.stub(:successful?).and_return true
      StripeWrapper::Charge.stub(:create).and_return charge
      post :create, user: user_params
      expect(User.last.email).to eq user_params[:email]
    end

    context 'with valid user data and a successful credit card charge' do
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return true
        StripeWrapper::Charge.stub(:create).and_return charge
        post :create, user: user_params
      end

      it 'sets @user based on user params' do
        expect(assigns(:user).full_name).to eq user_params[:full_name]
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to login_path
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_a String
      end

      it 'sends an email with valid input' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'sends email to the newly registered user' do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq [user_params[:email]]
      end

      it 'sends the welcome message' do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include "Welcome to Myflix, #{user_params[:full_name]}"
      end
    end

    context 'with successful registration through a valid invite token' do
      let(:invite) { Fabricate :invitation }

      before do
        charge = double('charge')
        charge.stub(:successful?).and_return true
        StripeWrapper::Charge.stub(:create).and_return charge
        post :create, user: user_params, invite_token: invite.token
      end

      it 'sets @invitation to the Invitation with the passed token, if an invite token is provided' do
        expect(assigns :invitation).to eq invite
      end

      it 'creates a new follow, in which the invited user is following the inviting user' do
        expect(User.last.guides).to include invite.inviter
      end

      it 'creates a new follow, in which the inviting user is following the invited user' do
        expect(invite.inviter.guides).to include User.last
      end
    end

    context 'with invalid user data' do
      before do
        # Here, no mocks/stubs are provided to handle stripe charges, but the tests still pass, because no charges are attempted without valid user data.
        post :create, user: {email: '', full_name: '', password:''}
      end

      it 'does not save @user to the database' do
        expect(User.find_by email: user_params[:email]).to eq nil
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end
    end

    context 'with a declined credit card charge' do
      before do
        @outbound_queue_count = ActionMailer::Base.deliveries.count
        charge = double('charge')
        charge.stub(:successful?).and_return false
        StripeWrapper::Charge.stub(:create).and_return charge
        charge.stub(:error_message).and_return('Your card was declined.')
        post :create, user: user_params
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to eq 'Your card was declined.'
      end

      it 'redirects to the register path' do
        expect(response).to redirect_to register_path
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries.count).to eq @outbound_queue_count
      end
    end
  end

  describe 'GET show' do
    let(:user) { Fabricate :user }

    it_behaves_like 'ApplicationController#require_login' do
      let(:action) { get :show, id: user.slug }
    end

    it 'sets @user to the user defined by params[:id]' do
      test_login user
      get :show, id: user.slug
      expect(assigns :user).to eq user
    end
  end
end
