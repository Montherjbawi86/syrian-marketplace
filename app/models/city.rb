class City < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :listings, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :name_ar, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "id", "listings_count", "name", "name_ar", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["listings", "users"]
  end

  def listings_count
    listings.active.count
  end

  def to_s
    name_ar
  end
end
