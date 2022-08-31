class CreateCoursesExamSittings < ActiveRecord::Migration[6.1]
  def change
    create_table :courses_exam_sittings do |t|
      t.integer :course_id
      t.integer :exam_sitting_id
      t.timestamps
    end
  end
end
