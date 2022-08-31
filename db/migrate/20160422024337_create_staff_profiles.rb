class CreateStaffProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_profiles do |t|
      t.references :staff, index: true
      t.timestamps null: false
    end
  end
end
