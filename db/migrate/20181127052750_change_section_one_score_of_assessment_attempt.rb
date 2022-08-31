class ChangeSectionOneScoreOfAssessmentAttempt < ActiveRecord::Migration[6.1]
  def change
    change_column :assessment_attempts, :section_one_score, :integer, default: 0
  end
end
