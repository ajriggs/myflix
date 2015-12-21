# unit helpers

def render_queue(user, count)
  queue = count.times.map do |i|
    item = Fabricate :queue_item, position: i + 1, user: user
  end
  queue.each do |item|
    Fabricate :review, user: user, video: item.video, rating: 5
  end
  queue
end

# service helpers

def test_login(user = nil)
  user ||=  Fabricate :user
  session[:user_id] = user.id
end

def test_logout
  session[:user_id] = nil
end

def render_queue_params(queue=nil)
  queue ||= render_queue(Fabricate :user, 4)
  queue_params = queue.each.map do |item|
    { id: item.id, position: item.position, rating: item.rating }
  end
end

# acceptance helpers

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
