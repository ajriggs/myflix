def test_login(user = nil)
  user ||=  Fabricate :user
  session[:user_id] = user.id
end

def test_logout
  session[:user_id] = nil
end
