class CreateSubcategories < ActiveRecord::Migration[7.0]
  def change
    create_table :subcategories do |t|
      t.string :name
      t.string :name_ar
      t.integer :category_id
      t.boolean :active

      t.timestamps
    end
  end
end
