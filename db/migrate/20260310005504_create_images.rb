class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.integer :listing_id
      t.string :image
      t.integer :position

      t.timestamps
    end
  end
end
