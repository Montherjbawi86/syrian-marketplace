class JobApplication < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :listing

  has_one_attached :cv

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :cover_letter, presence: true, length: { minimum: 50 }

  enum status: { pending: 0, reviewed: 1, contacted: 2, rejected: 3, accepted: 4 }
  enum applied_via: { website: 0, whatsapp: 1, email: 2, phone: 3 }

  def whatsapp_apply_url
    "https://wa.me/#{listing.user.phone.gsub(/[^0-9+]/, '')}?text=السلام عليكم، أنا أتقدم لوظيفة #{listing.title_ar}%0aالاسم: #{name}%0aالبريد: #{email}%0aالهاتف: #{phone}%0a%0a#{cover_letter}"
  end
end
