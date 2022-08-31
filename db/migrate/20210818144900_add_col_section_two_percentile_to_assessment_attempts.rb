class AddColSectionTwoPercentileToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :section_two_percentile, :float, default: 0.0
    add_column :assessment_attempts, :section_two_raw_score, :integer, default: 0
  end
end
