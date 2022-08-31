class SetAssessmentAttemptIdsInSectionAttempts < ActiveRecord::Migration[6.1]
  def up
    SectionAttempt.all.each do |sa|
      sa.update_attribute(:assessment_attempt_id, sa.attemptable_id)
    end
  end
end
