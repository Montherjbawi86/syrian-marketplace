class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :name_ar
      t.boolean :active
      t.integer :listings_count

      t.timestamps
    end
  end
end
