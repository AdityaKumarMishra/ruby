class CreateJoinTableTagTutorProfile < ActiveRecord::Migration[6.1]
  def change
    create_join_table :tags, :tutor_profiles do |t|
      # t.index [:tag_id, :tutor_profile_id]
      # t.index [:tutor_profile_id, :tag_id]
    end
  end
end
