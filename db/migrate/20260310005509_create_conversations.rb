class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.integer :listing_id
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :status
      t.datetime :last_message_at

      t.timestamps
    end
  end
end
