def login(user=nil)
  user ||= Fabricate :user
  visit login_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Sign In'
end

def click_home_page_link
click_link 'MyFLiX'
end

def expect_to_view_video_page(video)
  expect(current_path).to eq "/videos/#{video.slug}"
end

def expect_to_view_category_page(category)
  expect(current_path).to eq "/categories/#{category.slug}"
end

def user_should_follow(name:)
  visit people_path
  expect(page).to have_content name
end

def expect_successful_registration
  expect(page).to have_content 'Successfully registered!'
end

def provide_user_information
  fill_in :user_email, with: invite_attributes[:email]
  fill_in :user_password, with: 'password'
  fill_in :user_full_name, with: invite_attributes[:name]
end

def subscribe_with_credit_card(card_number)
  fill_in :card_number, with: card_number
  fill_in :cvc, with: '123'
  select '1 - January', from: :date_month
  select (Date.today.year + 4), from: :date_year
  click_button 'Sign Up'
end
