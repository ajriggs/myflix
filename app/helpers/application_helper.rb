module ApplicationHelper
  def rating_choices(selected=nil)
    options_for_select((1..5).map { |n| [pluralize(n, 'Star'), n] }, selected)
  end

  def gravatar_image_url(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end
end
