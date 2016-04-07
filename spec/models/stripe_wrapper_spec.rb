require 'spec_helper'

describe StripeWrapper::Charge, :vcr do
  let(:token) { Stripe::Token.create(card: { number: card_number, exp_year: Date.today.year + 4, exp_month: 01 }).id }

  let(:charge) { StripeWrapper::Charge.create amount: 999, description: 'test', token: token }

  describe 'Charge#create' do
    context 'when charge is accepted' do
      let(:card_number) { '4242424242424242' }

       it 'has a response of class Stripe::Charge' do
         expect(charge.response).to be_a Stripe::Charge
       end

       it 'has the status :success' do
         expect(charge.status).to eq :success
       end
    end

    context 'when charge is declined' do
      let(:card_number) { '4000000000000002' }

      it 'has a response of class Stripe::CardError' do
        expect(charge.response).to be_a Stripe::CardError
      end

      it 'has the status :error' do
        expect(charge.status).to eq :error
      end
    end
  end

  describe '#error_message' do
    context 'when charge is accepted' do
      let(:card_number) { '4242424242424242' }

      it 'returns nil' do
        expect(charge.error_message).to be nil
      end
    end

    context 'when the charge is declined' do
      let(:card_number) { '4000000000000002' }

      it "returns stripe's error message" do
        expect(charge.error_message).to eq 'Your card was declined.'
      end
    end
  end

  describe '#successful' do
    context 'when charge is accepted' do
      let(:card_number) { '4242424242424242'}

      it 'returns true' do
        expect(charge.successful?).to be true
      end
    end

    context 'when charge is declined' do
      let(:card_number) { '40000000000002'}

      it 'returns false' do
        expect(charge.successful?).to be false
      end
    end
  end
end
