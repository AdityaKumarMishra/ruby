class RemoveNanValuesFromAssessmentAttempts < ActiveRecord::Migration[6.1]
  def up
    AssessmentAttempt.where(percentile: Float::NAN).update_all(percentile: 80)
  end
end
