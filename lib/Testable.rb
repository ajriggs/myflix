module Testable
  # unit/model helpers



  # functional helpers
  def test_login(user = nil)
    return session[:user_id] = Fabricate(:user).id if user == nil
    session[:user_id] = user.id
  end

  def test_logout
    session[:user_id] = nil
  end

  def faker_name
    Faker::Name.name
  end

  def faker_email
    Faker::Internet.email
  end

  def faker_lorem(word_count)
    Faker::Lorem.words(word_count).join ' '
  end

  # integration helpers

end
