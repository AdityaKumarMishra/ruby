class CreateMcqCourseVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_course_versions do |t|
      t.references :mcq_stem, index: true, foreign_key: true
      t.references :course_version, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
