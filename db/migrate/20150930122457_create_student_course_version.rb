class CreateStudentCourseVersion < ActiveRecord::Migration[6.1]
  def change
    create_table :students_course_versions do |t|
      t.references :user
      t.references :course_version
    end
  end
end
