class CreateLiveExams < ActiveRecord::Migration[6.1]
  def change
    create_table :live_exams do |t|
      t.integer :section_one_score, default: 0
      t.integer :section_two_score, default: 0
      t.integer :section_three_score, default: 0
      t.integer  :course_id
      t.integer :user_id
      t.integer :total_score, default: 0
      t.float :section_one_percentile, default: 0.0
      t.float :section_two_percentile, default: 0.0
      t.float :section_three_percentile, default: 0.0
      t.float :total_percentile, default: 0.0
      t.string :section_type
      t.timestamps null: false
    end
  end
end
