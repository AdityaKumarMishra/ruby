class CreateMockExamEssays < ActiveRecord::Migration[6.1]
  def up
    create_table :mock_exam_essays do |t|

      t.integer  :course_id
      t.integer :user_id
      t.integer :live_exam_id
      t.integer :status, default: 0
      t.datetime :marked_at
      t.integer :assigned_tutors, array: true, default: []
      t.timestamps null: false
    end
  end

  def down
    drop_table :mock_exam_essays
  end
end
