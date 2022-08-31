class AddCourseToEnrolment < ActiveRecord::Migration[6.1]
  def change
    add_reference :enrolments, :course, index: true, foreign_key: true
  end
end
