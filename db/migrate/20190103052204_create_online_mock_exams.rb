class CreateOnlineMockExams < ActiveRecord::Migration[6.1]
  def change
    create_table :online_mock_exams do |t|
      t.string :title
      t.text :instruction
      t.boolean :published, default: false
      t.timestamps null: false
    end
  end
end
