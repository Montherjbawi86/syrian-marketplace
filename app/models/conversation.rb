class Conversation < ApplicationRecord
  belongs_to :listing
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  has_many :messages, dependent: :destroy

  validates :listing_id, uniqueness: { scope: [:buyer_id, :seller_id] }

  enum status: { active: 0, archived: 1, completed: 2 }

  def other_user(user)
    user == buyer ? seller : buyer
  end

  def last_message
    messages.last
  end

  def unread_count_for(user)
    messages.where(read: false).where.not(user_id: user.id).count
  end
end
