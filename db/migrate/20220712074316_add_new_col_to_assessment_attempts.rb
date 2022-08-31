class AddNewColToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :exam_mode, :integer
  end
end
