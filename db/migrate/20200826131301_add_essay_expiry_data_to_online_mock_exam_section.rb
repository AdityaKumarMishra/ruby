class AddEssayExpiryDataToOnlineMockExamSection < ActiveRecord::Migration[6.1]
  def change
  	add_column :online_mock_exam_sections, :essay_expire_time, :date
  end
end
