class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.integer :user_id
      t.string :title
      t.string :title_ar
      t.text :description
      t.text :description_ar
      t.decimal :price
      t.integer :condition
      t.integer :listing_type
      t.integer :status
      t.integer :city_id
      t.integer :category_id
      t.integer :subcategory_id
      t.integer :views_count
      t.boolean :whatsapp_contact
      t.boolean :phone_contact
      t.boolean :email_contact
      t.boolean :featured
      t.boolean :urgent

      t.timestamps
    end
  end
end
