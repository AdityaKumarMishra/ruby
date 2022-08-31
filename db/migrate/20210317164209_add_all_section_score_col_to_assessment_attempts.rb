class AddAllSectionScoreColToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :all_section_score, :integer, default: 0
  end
end
