require 'spec_helper'

describe UserRegistration do
  describe '#initialize' do
    it 'sets the user attribute' do
      registration = UserRegistration.new Fabricate :user
      expect(registration.user).to be_present
    end
  end

  describe '#register' do
    let(:user) { Fabricate.build :user }

    context 'with valid user data & a successful credit card charge' do
      let(:charge) { double :charge, successful?: true }

      before do
        # it successfully charges the user
        expect(StripeWrapper::Charge).to receive(:create).and_return charge
        @registration = UserRegistration.new(user).register '123123'
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it 'saves the user to the database' do
        expect(User.first).to eq user
      end

      it 'sets the status attribute to :success' do
        expect(@registration.status).to be :success
      end

      it 'sends a welcome email' do
        expect(ActionMailer::Base.deliveries.last.subject).to eq 'Welcome to Myflix!'
      end

      it 'sends the email to the newly-registered user' do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
      end
    end

    context 'with invalid user data' do
      before do
        user.email = ''
        # it does not attempt to charge the user
        expect(StripeWrapper::Charge).not_to receive :create
        @registration = UserRegistration.new(user).register '123123'
      end

      it 'does not save the user to the database' do
        expect(User.count).to eq 0
      end

      it 'sets the status attribute to :error' do
        expect(@registration.status).to be :error
      end

      it 'sets the error_message attribute' do
        expect(@registration.error_message).to eq 'Your submission contains validation errors. Please fix the highlighted fields before submitting again.'
      end

      it 'does not send any emails' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    context 'with a declined credit card charge' do
      let(:charge) { double :charge, successful?: false, error_message: 'Your card was declined.' }

      before do
        # it attempts to charge the user
        expect(StripeWrapper::Charge).to receive(:create).and_return charge
        @registration = UserRegistration.new(user).register '123123'
      end

      it 'does not save the user to the database' do
        expect(User.count).to eq 0
      end

      it 'sets the status attribute to :error' do
        expect(@registration.status).to eq :error
      end

      it 'sets the error_message attribute' do
        expect(@registration.error_message).to eq 'Your card was declined.'
      end

      it 'does not send any emails' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
  end

  describe '#handle_invite' do
    let(:user) { Fabricate.build :user }
    let(:inviter) { Fabricate :user }
    let(:invite) { double :invite, inviter: inviter }

    context 'with a valid invitation provided' do
      before do
        expect(Invitation).to receive(:find_by).and_return invite
        expect(invite).to receive(:delete).and_return nil
        UserRegistration.new(user).handle_invite('123123')
      end

      it 'makes the inviting user follow the invited user' do
        expect(inviter.followers).to include user
      end

      it 'makes the invited user follow the inviting user' do
        expect(user.followers).to include inviter
      end

      it 'removes the invitation from the db' do
        expect(Invitation.count).to eq 0
      end
    end

    context 'without a valid invitation provided' do
      before { UserRegistration.new(user).handle_invite nil }

      it 'does not make the new user follow another user' do
        expect(user.followers).to be_empty
      end
    end
  end
end
