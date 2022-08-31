class CreateCourseVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :course_versions do |t|
      t.integer :version_number
      t.datetime :date_added
      t.integer :class_size
      t.date :expiary_date
      t.datetime :enrolment_end_added
      t.integer :students_count
      t.references :course
      t.timestamps null: false
    end
  end
end
