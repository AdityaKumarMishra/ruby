class CreateOnlineMockDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :online_mock_documents do |t|
      t.integer :online_mock_exam_id
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.attachment :document

      t.timestamps null: false
    end
  end
end
