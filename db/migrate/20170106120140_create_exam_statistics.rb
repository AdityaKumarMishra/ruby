class CreateExamStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_statistics do |t|
      t.integer :total, default: 0
      t.integer :incorrect, default: 0
      t.integer :correct, default: 0
      t.integer :not_attempted, default: 0
      t.integer :time_taken
      t.integer :user_id
      t.integer :tag_id
      t.integer :course_id
      t.integer :section_attempt_id
      t.timestamps null: false
    end
  end
end
