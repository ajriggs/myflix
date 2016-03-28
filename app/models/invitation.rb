class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'

  validates :email, presence: true
  validates :name, presence: true

  before_save :render_token!

  def inviter_name
    inviter.full_name
  end

  def invitee_already_registered?
    !!(User.find_by email: email)
  end

  private

  def render_token!
    self.token = SecureRandom.urlsafe_base64.downcase
  end
end
