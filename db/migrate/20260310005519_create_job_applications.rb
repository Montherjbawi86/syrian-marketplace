class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.integer :user_id
      t.integer :listing_id
      t.string :name
      t.string :email
      t.string :phone
      t.string :cv
      t.text :cover_letter
      t.integer :status
      t.string :applied_via

      t.timestamps
    end
  end
end
