class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewee, class_name: 'User'
  belongs_to :listing, optional: true

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :content, presence: true

  after_save :update_reviewee_rating

  scope :recent, -> { order(created_at: :desc) }

  private

  def update_reviewee_rating
    reviewee.update(
      average_rating: reviewee.received_reviews.average(:rating).to_f.round(1)
    )
  end
end
