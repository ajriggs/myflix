require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with a valid email address provided' do
      let(:riggs) { Fabricate :user }
      let(:password_email) { ActionMailer::Base.deliveries.last }
      
      before { post :create, email: riggs.email }

      it 'renders a new token for the user with provided email address' do
        expect(User.last.token).to be_present
      end

      it 'sends an email, to verify password reset' do
        outbound_queue_count = ActionMailer::Base.deliveries.count
        post :create, email: riggs.email
        expect(ActionMailer::Base.deliveries.count).to eq (outbound_queue_count + 1)
      end

      it 'sends the password reset email to the correct recipient' do
        expect(password_email.to).to eq [riggs.email]
      end

      it 'provides the correct password reset link in the email' do
        expect(password_email.body).to include "/reset_password/#{User.last.token}"
      end

      it 'redirects the user to the email confirmed path' do
        expect(response).to redirect_to email_confirmed_path
      end
    end

    context 'immediately following another password reset request from the same user' do
      let(:riggs) { Fabricate :user }

      before { post :create, email: riggs.email }

      it 'overwrites the previous token with a new token, rendering the first expired' do
        first_token = User.last.token
        post :create, email: riggs.email
        expect(User.last.token).not_to eq first_token
      end

      it 'sends out another email to the user' do
        first_email = ActionMailer::Base.deliveries.last
        post :create, email: riggs.email
        expect(ActionMailer::Base.deliveries.last).to_not eq first_email
      end
    end

    context 'with an invalid email address (not registered with myflix)' do
      let(:riggs) { Fabricate :user }

      it 'does not send a password reset email' do
        outbound_queue_count = ActionMailer::Base.deliveries.count
        post :create, email: 'nobody@nothing.com'
        expect(ActionMailer::Base.deliveries.count).to eq outbound_queue_count
      end

      it 'sets flash[:error]' do
        post :create, email: 'nobody@nothing.com'
        expect(flash[:error]).to be_present
      end

      it 'redirects the user to the forgot password path' do
        post :create, email: 'nobody@nothing.com'
        expect(response).to redirect_to forgot_password_path
      end
    end
  end
end
