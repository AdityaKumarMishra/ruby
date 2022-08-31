class RemoveStudentCountFromCourse < ActiveRecord::Migration[6.1]
  def change
    remove_column :courses, :student_count
  end
end
