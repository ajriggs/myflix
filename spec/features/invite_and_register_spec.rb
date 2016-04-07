require 'spec_helper'

feature 'A new user registers for myflix', :js, :vcr do
  given!(:riggs) { Fabricate :user, full_name: 'Riggs', email: 'riggs@example.com', password: 'password' }
  given!(:invite_attributes) { Fabricate.attributes_for :invitation }

  context 'from an invitation email' do
    background do
      login riggs
      visit new_invitation_path
    end

    scenario 'user invites a friend with an unregistered email' do
      invite_friend_via_email
      accept_email_invite
      provide_user_information
      subscribe_with_credit_card '4242424242424242'
      expect_successful_registration

      invitee_signs_in
      user_should_follow name_string: riggs.full_name
      visit logout_path

      login riggs
      user_should_follow name_string: invite_attributes[:name]

      clear_email
    end

    scenario 'user invites someone with an already-registered email' do
      user_invites_himself
      expect(page).to have_content 'That person has already registered for myflix!'
    end
  end

  scenario 'invalid credit card number is provided at registration' do
    visit register_path
    provide_user_information
    subscribe_with_credit_card '123123123'
    expect(page).to have_content 'Your card number is incorrect.'
  end

  scenario 'credit card charge is declined at registration' do
    visit register_path
    provide_user_information
    subscribe_with_credit_card '4000000000000002'
    expect(page).to have_content 'Your card was declined.'
  end

  def invite_friend_via_email
    fill_in :invitation_name, with: invite_attributes[:name]
    fill_in :invitation_email, with: invite_attributes[:email]
    fill_in :invitation_message, with: invite_attributes[:message]
    click_button 'Send Invitation'
    expect(page).to have_content 'Invite sent!'
    visit logout_path
  end

  def accept_email_invite
    open_email invite_attributes[:email]
    expect(current_email).to have_content invite_attributes[:message]
    current_email.click_link 'Join myflix today!'
    email_field_value = find('#user_email').value
    expect(email_field_value).to eq invite_attributes[:email]
  end

  def invitee_signs_in
    visit login_path
    fill_in :email, with: invite_attributes[:email]
    fill_in :password, with: 'password'
    click_button 'Sign In'
  end

  def user_invites_himself
    fill_in :invitation_name, with: riggs.full_name
    fill_in :invitation_email, with: riggs.email
    fill_in :invitation_message, with: invite_attributes[:message]
    click_button 'Send Invitation'
  end
end
