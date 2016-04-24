class UserRegistration
  attr_accessor :user, :status, :error_message
  def initialize(user)
    self.user = user
  end

  def register(stripe_token)
    charge_options = { amount: 999, source: stripe_token, description: "First-month subscription fee for #{user.full_name}" }
    charge = StripeWrapper::Charge.create charge_options if user.valid?
    if !charge
      self.status = :error
      self.error_message = 'Your submission contains validation errors. Please fix the highlighted fields before submitting again.'
      self
    elsif charge.successful?
      self.status = :success
      user.save
      AppMailer.delay.welcome_user_upon_registration(user.id)
      self
    else
      self.status = :error
      self.error_message = charge.error_message
      self
    end
  end

  def successful?
    status == :success
  end

  def handle_invite(invite_token)
    invite = Invitation.find_by token: invite_token
    if invite
      user.follow!(invite.inviter)
      invite.inviter.follow!(user)
      invite.delete
    end
  end
end
