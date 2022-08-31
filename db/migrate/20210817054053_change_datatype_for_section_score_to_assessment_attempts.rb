class ChangeDatatypeForSectionScoreToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    change_column :assessment_attempts, :section_one_score, :float, default: 0.0
    change_column :assessment_attempts, :section_three_score, :float, default: 0.0
  end
end
