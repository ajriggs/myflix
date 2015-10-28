module Testable
  # unit/model helpers



  # functional helpers
  def test_login
    session[:user_id] = Fabricate(:user).id
  end

  def faker_name
    Faker::Name.name
  end

  def faker_email
    Faker::Internet.email
  end

  def faker_lorem(word_count)
    Faker::Lorem.words(word_count).join(' ')
  end

  # integration helpers

end
