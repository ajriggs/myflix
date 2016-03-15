require 'spec_helper'

feature 'Social Networking' do
  given(:riggs) { Fabricate :user }
  given(:james) { Fabricate :user }
  given(:south_park) { Fabricate :video, title: 'South Park' }
  given!(:james_review) { Fabricate :review, user: james, video: south_park }

  background { login riggs }

  scenario "current user views a user profile, follows, and unfollows, another user" do
    visit video_path(south_park)
    click_link "#{james.full_name}"
    expect(page).to have_content "#{james.full_name}'s video collection"
    click_link 'Follow'
    expect(page).to have_content "#{james.full_name}"
    find('#delete_connection_1').click
    expect(page).to_not have_content "#{james.full_name}"
  end
end
