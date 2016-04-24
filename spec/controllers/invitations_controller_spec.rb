require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    let(:riggs) { Fabricate :user }

    it_behaves_like 'user can only access if logged in' do
      let(:action) { get :new }
    end

    it 'sets @invitation as a new Invitation instance' do
      test_login riggs
      get :new
      expect(assigns :invitation).to be_a_new Invitation
    end
  end

  describe 'POST create' do
    let(:riggs) { Fabricate :user }
    let(:james) { Fabricate :user }
    let(:riggs_invite_params) { Fabricate.attributes_for :invitation, name: 'riggs', message: "please join myflix!", email: riggs.email }

    it_behaves_like 'user can only access if logged in' do
      let(:action) { post :create, invitation: riggs_invite_params }
    end

    context 'with params input' do
      before do
        test_login james
        post :create, invitation: riggs_invite_params
      end

      it 'sets @invitation.name based on params[:invitation][:name]' do
        expect(assigns(:invitation).name).to eq riggs_invite_params[:name]
      end

      it 'sets @invitation.email based on params[:invitation][:email]' do
        expect(assigns(:invitation).email).to eq riggs_invite_params[:email]
      end

      it 'sets @invitation.message based on params[:invitation][:message]' do
        expect(assigns(:invitation).message).to eq riggs_invite_params[:message]
      end

      it 'sets @invitation.inviter based on the logged in user' do
        expect(assigns(:invitation).inviter).to eq james
      end
    end

    context 'with valid inputs' do
      let(:jon_invite_params) { Fabricate.attributes_for :invitation, name: 'jon', message: "please join myflix!", email: 'jon@example.com' }
      let(:latest_invite_email) { ActionMailer::Base.deliveries.last }

      before do
        test_login james
        post :create, invitation: jon_invite_params
      end

      it 'saves the new Invitation to the db' do
        expect(Invitation.last.email).to eq jon_invite_params[:email]
      end

      context 'while sending invite email' do
        it "sends a new email to the invitation's email address" do
          expect(ActionMailer::Base.deliveries.last.to).to eq [jon_invite_params[:email]]
        end

        it "provides a url to the register path in the email" do
          expect(latest_invite_email.body).to include register_path(token: Invitation.last.token)
        end

        it "renders the message sent by by in the inviter" do
          expect(latest_invite_email.body).to include jon_invite_params[:message]
        end

        it 'tells the invited person who invited them, in the subject line' do
          expect(latest_invite_email.subject).to include james.full_name
        end
      end
    end

    context 'while inviting an already-registered email address' do
      before do
        test_login james
        post :create, invitation: riggs_invite_params
      end

      it 'does not save a new Invitation to the db' do
        expect(Invitation.count).to eq 0
      end

      it 'sets flash.now[:error]' do
        expect(flash.now[:error]).to be_present
      end

      it 'renders the new invitation template' do
        expect(response).to render_template :new
      end
    end

    context 'with invalid inputs' do
      let(:invalid_invite_params) { Fabricate.attributes_for :invitation, name: '', email: '' }
      
      before do
        test_login james
        post :create, invitation: invalid_invite_params
      end

      it 'does not save the Invitation to the db' do
        expect(Invitation.count).to be 0
      end

      it 'sets flash.now[:error]' do
        expect(flash.now[:error]).to be_present
      end

      it 'renders the new invitation template' do
        expect(response).to render_template :new
      end
    end
  end
end
