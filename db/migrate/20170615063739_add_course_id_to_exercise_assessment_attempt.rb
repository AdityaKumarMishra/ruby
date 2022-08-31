class AddCourseIdToExerciseAssessmentAttempt < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :course_id, :integer
    add_column :assessment_attempts, :course_id, :integer
  end
end
