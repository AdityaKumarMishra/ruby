class RemoveNewCourseIdFromEnrolment < ActiveRecord::Migration[6.1]
  def change
    remove_column :enrolments, :new_course_id, :integer
  end
end
