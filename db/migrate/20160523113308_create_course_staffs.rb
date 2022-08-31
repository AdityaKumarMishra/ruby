class CreateCourseStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :course_staffs do |t|
      t.references :staff_profile, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
