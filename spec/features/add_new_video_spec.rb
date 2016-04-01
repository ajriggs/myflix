require 'spec_helper'

feature 'Admin adds a new video to myflix' do
  given(:admin) { Fabricate :user, admin: true }
  given!(:fantasy) { Fabricate :category, name: 'Fantasy' }

  scenario 'admin successfully adds a new video to the db' do
    login admin
    visit new_admin_video_path
    fill_in 'Title', with: 'Game of Thrones'
    select 'Fantasy', from: 'video_category_id'
    fill_in 'Tagline', with: 'Power may be attained by many means: betray, fortune, family, even dragons...'
    attach_file 'Small cover', test_image_upload_path('game_of_thrones.jpg')
    attach_file 'Large cover', test_image_upload_path('game_of_thrones_large.jpg')
    fill_in 'Video url', with: 'http://www.example.com/video'
    click_button 'Add Video'
    visit logout_path

    login
    expect(page).to have_selector("img[src='/spec/game_of_thrones.jpg']")
    find("a[href='/videos/game-of-thrones']").click
    expect(page).to have_selector("img[src='/spec/game_of_thrones_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/video']")
  end

  def test_image_upload_path(file_name)
    "public/spec/#{file_name}"
  end
end
