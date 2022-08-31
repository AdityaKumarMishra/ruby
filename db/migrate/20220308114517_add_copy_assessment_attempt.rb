class AddCopyAssessmentAttempt < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_attempts, :copy_id, :integer
  end
end
