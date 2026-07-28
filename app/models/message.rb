class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  after_create :update_conversation_timestamp

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update(read: true)
  end

  private

  def update_conversation_timestamp
    conversation.touch(:last_message_at)
  end
end
