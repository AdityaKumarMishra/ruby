class AddMarkerToEssayTutorResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_tutor_responses, :staff_profile_id, :int
  end
end
