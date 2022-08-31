class CreateJoinTableExcludedTagTutorProfile < ActiveRecord::Migration[6.1]
  def change
    create_table :excluded_tags_tutor_profiles do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :tutor_profile, index: true, foreign_key: true
    end
  end
end
