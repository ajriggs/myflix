require 'spec_helper'

feature 'user resets their password' do
  given(:riggs) { Fabricate :user }

  background { visit login_path }

  scenario 'user forgets password, requests to reset it, and follows reset process' do
    click_link 'Forgot your password?'
    fill_in :email, with: riggs.email
    click_button 'Send Email'
    open_email riggs.email
    current_email.click_link 'Reset your password!'
    fill_in :user_password, with: 'new_password'
    click_button 'Reset Password'
    fill_in :email, with: riggs.email
    fill_in :password, with: 'new_password'
    click_button 'Sign In'
    expect(page).to have_content "Welcome, #{riggs.full_name}"
  end
end
