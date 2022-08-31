class AddStudentClassRefferenceToCourseVersion < ActiveRecord::Migration[6.1]
  def up
    add_reference :student_classes, :course_version, index: true, foreign_key: true
  end

  def down
    remove_reference :student_classes, :course_version
  end
end
