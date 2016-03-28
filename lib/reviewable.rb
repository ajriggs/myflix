module Reviewable
  extend ActiveSupport::Concern

  included do
    has_many :reviews, -> { order('created_at DESC') }
  end
end
