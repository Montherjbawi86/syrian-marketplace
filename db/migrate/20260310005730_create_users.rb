class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Devise fields
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      ## Custom fields (combine AddFieldsToUsers here)
      t.string :username
      t.string :phone
      t.integer :city_id
      t.integer :role, default: 0
      t.integer :status, default: 0
      t.boolean :jobseeker, default: false
      t.boolean :company, default: false
      t.text :bio
      t.float :average_rating

      ## Trackable (optional but useful)
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :username,             unique: true
    add_index :users, :phone
    add_index :users, :city_id
  end
end
