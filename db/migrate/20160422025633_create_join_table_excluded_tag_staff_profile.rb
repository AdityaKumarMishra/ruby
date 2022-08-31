class CreateJoinTableExcludedTagStaffProfile < ActiveRecord::Migration[6.1]
  def change
    create_table :excluded_tags_staff_profiles do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :staff_profile, index: true, foreign_key: true
    end
  end
end
