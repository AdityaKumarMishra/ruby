class CreateOnlineMockExamSections < ActiveRecord::Migration[6.1]
  def change
    create_table :online_mock_exam_sections do |t|
    	t.integer :online_mock_exam_id
    	t.integer :section_type
      t.integer :position
    	t.integer :staff_id
      t.boolean :published
      t.integer :online_exam_id
      t.integer :essay_id
      t.attachment :document
      t.attachment :video
      t.string :video_title
    	t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.timestamps null: false
    end
  end
end
