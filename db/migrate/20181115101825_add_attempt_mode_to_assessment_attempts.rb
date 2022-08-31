class AddAttemptModeToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :attempt_mode, :integer
  end
end
