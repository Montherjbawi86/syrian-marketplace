class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :city
  belongs_to :category
  belongs_to :subcategory, class_name: 'Subcategory', optional: true

  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  has_many :conversations, dependent: :destroy
  has_many :messages, through: :conversations
  has_many :job_applications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many_attached :images

  validates :title, presence: true
  validates :title_ar, presence: true
  validates :description, presence: true
  validates :description_ar, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :city_id, presence: true
  validates :category_id, presence: true

  # Enums
  enum condition: { brand_new: 0, like_new: 1, good: 2, fair: 3, poor: 4 }
  enum listing_type: { sell: 0, buy: 1, rent: 2, exchange: 3, wanted: 4, job: 5 }
  enum status: { draft: 0, active: 1, sold: 2, expired: 3, filled: 4 }

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :recent, -> { order(created_at: :desc) }
  scope :jobs, -> { joins(:category).where(categories: { category_type: 3 }) }
  scope :products, -> { joins(:category).where.not(categories: { category_type: 3 }) }
  scope :for_sale, -> { where(listing_type: :sell) }
  scope :for_rent, -> { where(listing_type: :rent) }
  scope :wanted, -> { where(listing_type: :wanted) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "city_id", "condition", "created_at", "description",
     "description_ar", "email_contact", "featured", "id", "listing_type",
     "phone_contact", "price", "status", "subcategory_id", "title",
     "title_ar", "updated_at", "urgent", "user_id", "views_count",
     "whatsapp_contact"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "city", "favorites", "favorited_by", "images_attachments",
     "images_blobs", "job_applications", "reviews", "subcategory", "user"]
  end

  # Instance methods
  def main_image
    images.first
  end

  def display_image(image, size = [300, 200])
    return nil unless image.attached?

    begin
      if image.representable?
        image.variant(resize_to_fill: size)
      else
        image
      end
    rescue => e
      Rails.logger.error "Image display error: #{e.message}"
      nil
    end
  end

  def favorited_by?(user)
    favorites.exists?(user: user)
  end

  def similar_listings(limit = 5)
    Listing.active
           .where(category_id: category_id)
           .where.not(id: id)
           .limit(limit)
  end

  def is_job?
    category&.category_type == 'jobs' || category&.category_type == 3
  end

  def formatted_price
    if is_job?
      case price
      when 0 then 'غير محدد'
      else ActionController::Base.helpers.number_to_currency(price, unit: 'ل.س', format: '%n %u', precision: 0)
      end
    else
      return 'مجاني' if price == 0
      ActionController::Base.helpers.number_to_currency(price, unit: 'ل.س', format: '%n %u', precision: 0)
    end
  end

  def condition_display
    case condition
    when 'brand_new' then 'جديد'
    when 'like_new' then 'كالجديد'
    when 'good' then 'جيد'
    when 'fair' then 'مقبول'
    when 'poor' then 'سيء'
    else condition
    end
  end

  def listing_type_display
    case listing_type
    when 'sell' then 'للبيع'
    when 'buy' then 'مطلوب للشراء'
    when 'rent' then 'للإيجار'
    when 'exchange' then 'للتبادل'
    when 'wanted' then 'مطلوب'
    when 'job' then 'وظيفة'
    end
  end

  def status_display
    case status
    when 'active'
      'نشط'
    when 'draft'
      'مسودة'
    when 'sold'
      'مباع'
    when 'expired'
      'منتهي'
    when 'filled'
      'تم الشغور'
    else
      status.to_s
    end
  end

  def whatsapp_url
    return "#" if user&.phone.blank?
    "https://wa.me/#{user.phone.gsub(/[^0-9+]/, '')}?text=السلام عليكم، أنا مهتم بـ #{title_ar}"
  end

  def whatsapp_contact?
    user&.phone.present?
  end

  def phone_contact?
    user&.phone.present?
  end
end
