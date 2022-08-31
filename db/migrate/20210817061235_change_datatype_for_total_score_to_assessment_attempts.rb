class ChangeDatatypeForTotalScoreToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
     change_column :assessment_attempts, :total_score, :float, default: 0.0
  end
end
