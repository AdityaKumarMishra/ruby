class AddAssessmentAttemptIdToSectionAttempts < ActiveRecord::Migration[6.1]
  def change
    add_reference :section_attempts, :assessment_attempt, index: true, foreign_key: true
  end
end
