module BelongsToUserable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
  end

  def user_name
    user.full_name
  end
end
