class AddJobFieldsToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :requirements, :text
    add_column :listings, :benefits, :text
    add_column :listings, :skills, :text
    add_column :listings, :job_type, :string
    add_column :listings, :experience_level, :string
    add_column :listings, :deadline, :date
  end
end
