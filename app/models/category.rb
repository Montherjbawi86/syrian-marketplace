class Category < ApplicationRecord
  has_many :subcategories, dependent: :destroy
  has_many :listings, through: :subcategories
  has_many :direct_listings, class_name: 'Listing', foreign_key: 'category_id'

  validates :name, presence: true, uniqueness: true
  validates :name_ar, presence: true, uniqueness: true

  enum category_type: { 
    general: 0, 
    real_estate: 1, 
    vehicles: 2, 
    jobs: 3, 
    services: 4,
    electronics: 5,
    fashion: 6,
    home_garden: 7,
    pets: 8,
    books: 9,
    sports: 10,
    beauty: 11,
    education: 12,
    food: 13,
    furniture: 14,
    tools: 15
  }

  scope :active, -> { where(active: true) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["active", "category_type", "created_at", "icon", "id", "name",
     "name_ar", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["direct_listings", "listings", "subcategories"]
  end

  def all_listings
    Listing.where('category_id = ? OR category_id IN (?)', id, subcategory_ids)
  end

  def listings_count
    all_listings.active.count
  end

  def to_s
    name_ar
  end

  def icon_class
    return icon if icon.present?

    case name
    when 'Vehicles' then 'fa-car'
    when 'Real Estate' then 'fa-home'
    when 'Jobs' then 'fa-briefcase'
    when 'Electronics' then 'fa-mobile-alt'
    when 'Fashion' then 'fa-tshirt'
    when 'Services' then 'fa-tools'
    when 'Pets' then 'fa-paw'
    when 'Books' then 'fa-book'
    when 'Sports' then 'fa-futbol'
    when 'Home & Garden' then 'fa-couch'
    when 'Beauty' then 'fa-spa'
    when 'Education' then 'fa-graduation-cap'
    when 'Food' then 'fa-utensils'
    when 'Furniture' then 'fa-chair'
    else 'fa-tag'
    end
  end
end
