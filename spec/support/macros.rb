# unit helpers



# service helpers

def test_login(user = nil)
  user ||=  Fabricate :user
  session[:user_id] = user.id
end

def test_logout
  session[:user_id] = nil
end

# feature helpers

def login(user=nil)
  user ||= Fabricate :user
  visit login_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Sign In'
end

def current_path
  current_url.split('.com')[1]
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
