require 'spec_helper'

feature 'User login' do
  given(:user) { Fabricate :user }
  scenario 'with valid, existing credentials' do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Sign In'
    expect(page).to have_content user.full_name
  end
end
