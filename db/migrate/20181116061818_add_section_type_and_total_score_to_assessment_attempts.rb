class AddSectionTypeAndTotalScoreToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :section_one_score, :integer, default: 0
    add_column :assessment_attempts, :section_three_score, :integer, default: 0
    add_column :assessment_attempts, :section_type, :string
    add_column :assessment_attempts, :total_score, :integer, default:0
  end
end
