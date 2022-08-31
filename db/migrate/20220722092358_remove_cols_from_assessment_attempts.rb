class RemoveColsFromAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    remove_column :assessment_attempts, :exam_mode
  end
end
