require 'spec_helper'

feature 'My Queue' do
  given(:comedy) { Fabricate :category, name: 'Comedy' }
  given!(:south_park) { Fabricate :video, title: 'South Park', tagline: 'kick tha baaaabyyyy!', category: comedy }
  given!(:monk) { Fabricate :video, title: 'Monk', tagline: 'We never actually saw this one.', category: comedy }
  given!(:star_wars) { Fabricate :video, title: 'Star Wars', tagline: 'Kylo Ren is not a Sith lord? Ooh..interesting!', category: comedy }

  scenario 'User Adds a video to the queue' do
    login
    add_to_queue south_park
    expect(page).to have_content 'added to your queue'
    click_queue_item_title_link south_park
    expect_to_view_video_page south_park
    expect_to_not_see_add_to_queue_button
    click_home_page_link
    add_to_queue monk
    click_queue_item_category_link south_park, 1
    expect_to_view_category_page comedy
    add_to_queue star_wars
    expect_a_queue_of_three_items
    # provide ints in this order: position, rating, row_number
    set_position_and_rating_for_row 3, 2, 1
    set_position_and_rating_for_row 1, 1, 2
    set_position_and_rating_for_row 2, 3, 3
    click_button 'Update Instant Queue'
    expect_row_to_be_queue_item 1, monk
    expect_row_to_have_rating 1, 1
    delete_row 1
    expect_user_to_not_have_queue_item monk
  end

  def add_to_queue(video)
    find("a[href='/videos/#{video.slug}']").click
    click_link '+ My Queue'
  end

  def click_queue_item_title_link(video)
    click_link video.title
  end

  def click_queue_item_category_link(video, row_number)
    within(:xpath, "//tr[@id='queue_item #{row_number}']") { click_link video.category.name }
  end

  def set_position_and_rating_for_row(position, rating, row_number)
    within(:xpath, "//tr[@id='queue_item #{row_number}']") do
      fill_in 'queue__position', with: position.to_s
      if rating == 0
        page.select 'No Rating', from: 'queue__rating'
      else
        rating_string = "#{rating} #{'Star'.pluralize(rating)}"
        page.select rating_string, from: 'queue__rating'
      end
    end
  end

  def delete_row(row_number)
    within(:xpath, "//tr[@id='queue_item #{row_number}']") do
      find("a[data-method='delete']").click
    end
  end

  def expect_to_not_see_add_to_queue_button
    expect(page).to_not have_content '+ My Queue'
  end

  def expect_a_queue_of_three_items
    expect(page).to have_xpath "//tr[@id='queue_item 3']"
  end

  def expect_row_to_be_queue_item(row_number, video)
    expect(page).to have_xpath "//tr[@id='queue_item #{row_number}']//td/a[@id='#{video.title}']"
  end

  def expect_row_to_have_rating(row_number, rating)
    expect(page).to have_xpath "//tr[@id='queue_item #{row_number}']//td/select[@id='queue__rating']/option[@selected='selected' and @value='#{rating }']"
  end

  def expect_user_to_not_have_queue_item(video)
    expect(page).to_not have_content video.title
  end
end
