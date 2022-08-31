class CreateOnlineMockVods < ActiveRecord::Migration[6.1]
  def change
    create_table :online_mock_vods do |t|
      t.string :title
      t.integer :online_mock_exam_id
      t.attachment :video

      t.timestamps null: false
    end
  end
end
