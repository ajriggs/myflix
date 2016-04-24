module Reviewable
  extend ActiveSupport::Concern

  included do
    has_many :reviews, -> { order('created_at DESC') }
  end

  def review_count
    reviews.count
  end
end
