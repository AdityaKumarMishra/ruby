class AddNewColSectionTwoScoreToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :section_two_score, :float, default: 0.0
  end
end
