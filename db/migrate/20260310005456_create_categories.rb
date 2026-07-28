class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :name_ar
      t.integer :category_type
      t.boolean :active
      t.string :icon

      t.timestamps
    end
  end
end
