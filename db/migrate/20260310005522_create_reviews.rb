class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id
      t.integer :reviewee_id
      t.integer :listing_id
      t.integer :rating
      t.text :content

      t.timestamps
    end
  end
end
