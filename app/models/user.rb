class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :city, optional: true
  
  has_many :listings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_listings, through: :favorites, source: :listing
  has_many :sent_messages, class_name: 'Message', foreign_key: 'user_id', dependent: :destroy
  has_many :conversations_as_buyer, class_name: 'Conversation', foreign_key: 'buyer_id', dependent: :destroy
  has_many :conversations_as_seller, class_name: 'Conversation', foreign_key: 'seller_id', dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :sent_reviews, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', foreign_key: 'reviewee_id', dependent: :destroy

  has_one_attached :avatar

  # Validations
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false, message: "هذا الاسم مستخدم بالفعل" },
                       length: { minimum: 3, maximum: 50, message: "يجب أن يكون بين 3 و 50 حرف" },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "يسمح فقط بأحرف إنجليزية وأرقام و_" },
                       allow_blank: false

  validates :phone, allow_blank: true, format: { with: /\A[0-9+\-\s]+\z/, message: "رقم هاتف غير صحيح" }

  # Enums
  enum role: { user: 0, moderator: 1, admin: 2 }
  enum status: { active: 0, suspended: 1, banned: 2 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { where(status: :active) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["average_rating", "bio", "city_id", "company", "created_at",
     "email", "id", "jobseeker", "phone", "role", "status",
     "updated_at", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["avatar_attachment", "avatar_blob", "city", "conversations_as_buyer",
     "conversations_as_seller", "favorite_listings", "favorites",
     "job_applications", "listings", "received_reviews", "sent_messages",
     "sent_reviews"]
  end

  # Instance methods
  def name
    username.presence || email.split('@').first
  end

  def jobseeker?
    jobseeker == true
  end

  def company?
    company == true
  end

  def unread_messages_count
    Message.joins(:conversation)
           .where(conversation: { buyer_id: id })
           .or(Message.joins(:conversation).where(conversation: { seller_id: id }))
           .where(read: false)
           .where.not(user_id: id)
           .count
  rescue
    0
  end

  def active_listings_count
    listings.active.count
  end

  def average_rating
    received_reviews.average(:rating).to_f.round(1) if received_reviews.any?
  end

  def to_s
    name
  end
end
