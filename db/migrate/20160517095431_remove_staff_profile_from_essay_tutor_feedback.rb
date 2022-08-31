class RemoveStaffProfileFromEssayTutorFeedback < ActiveRecord::Migration[6.1]
  def change
    remove_reference :essay_tutor_feedbacks, :staff_profile, index: true, foreign_key: true
  end
end
