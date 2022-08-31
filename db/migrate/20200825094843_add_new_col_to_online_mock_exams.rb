class AddNewColToOnlineMockExams < ActiveRecord::Migration[6.1]
  def change
    add_column :online_mock_exams, :per_city_exam_count, :integer, default: 1
  end
end
