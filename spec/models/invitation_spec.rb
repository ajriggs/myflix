require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name 'User' }
  it { should validate_presence_of :email }
  it { should validate_presence_of :name }

  let!(:invitation) { Fabricate :invitation }

  it 'renders a token before saving to the db' do
    expect(Invitation.first.token).to be_present
  end

  describe '#render_token!' do
    let(:riggs_invite) { Fabricate :invitation, name: 'riggs' }

    it 'sets [user].token as a 22-character string (to be emailed to a user who needs a password reset)' do
      expect(riggs_invite.token.length).to eq 22
    end

    it 'generates a a string with only lower-case letter characters' do
      expect(riggs_invite.token.downcase).to eq riggs_invite.token
    end
  end

  describe '#inviter_name' do
    let(:james) { Fabricate :user, full_name: 'james' }
    let(:riggs_invite) { Fabricate :invitation, name: 'riggs', inviter: james }

    it "returns the name of the inviter in an Invitation" do
      expect(riggs_invite.inviter_name).to eq 'james'
    end
  end

  describe '#invitee_already_registered?' do
    let(:james) { Fabricate :user, full_name: 'james' }
    let(:james_invite) { Fabricate :invitation, name: 'james', email: james.email }
    let(:riggs_invite) { Fabricate :invitation, name: 'riggs', inviter: james }

    it 'returns true if invited email address is already registered' do
      expect(james_invite.invitee_already_registered?).to be true
    end

    it 'returns false if invited email address is not yet registered' do
      expect(riggs_invite.invitee_already_registered?).to be false
    end
  end
end
