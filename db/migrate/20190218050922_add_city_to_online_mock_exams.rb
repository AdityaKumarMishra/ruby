class AddCityToOnlineMockExams < ActiveRecord::Migration[6.1]
  def change
    add_column :online_mock_exams, :city, :integer, default: 0
  end
end
