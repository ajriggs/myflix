require 'spec_helper'

feature 'User invites another user to register for myflix' do
  given(:riggs) { Fabricate :user, full_name: 'Riggs', email: 'riggs@example.com' }
  given(:invite_attributes) { Fabricate.attributes_for :invitation }

  background do
    login riggs
    visit new_invitation_path
  end

  scenario 'user invites a friend with an unregistered email' do
    user_invites_friend_via_email
    friend_accepts_email_invite
    friend_registers_via_invite_link

    friend_signs_in
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

  def user_invites_friend_via_email
    fill_in :invitation_name, with: invite_attributes[:name]
    fill_in :invitation_email, with: invite_attributes[:email]
    fill_in :invitation_message, with: invite_attributes[:message]
    click_button 'Send Invitation'
    expect(page).to have_content 'Invite sent!'
    visit logout_path
  end

  def friend_accepts_email_invite
    open_email invite_attributes[:email]
    expect(current_email).to have_content invite_attributes[:message]
    current_email.click_link 'Join myflix today!'
  end

  def friend_registers_via_invite_link
    email_field_value = find('#user_email').value
    expect(email_field_value).to eq invite_attributes[:email]
    fill_in :user_password, with: 'password'
    fill_in :user_full_name, with: invite_attributes[:name]
    click_button 'Sign Up'
    expect(page).to have_content 'Successfully registered!'
  end

  def friend_signs_in
    visit login_path
    fill_in :email, with: invite_attributes[:email]
    fill_in :password, with: 'password'
    click_button 'Sign In'
  end

  def user_should_follow(name_string:)
    visit people_path
    expect(page).to have_content name_string
  end

  def user_invites_himself
    fill_in :invitation_name, with: riggs.full_name
    fill_in :invitation_email, with: riggs.email
    fill_in :invitation_message, with: invite_attributes[:message]
    click_button 'Send Invitation'
  end
end
