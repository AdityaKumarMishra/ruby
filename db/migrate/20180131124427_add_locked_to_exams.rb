class AddLockedToExams < ActiveRecord::Migration[6.1]
  def change
  	add_column :online_exams, :locked, :boolean, default: false
  	add_column :diagnostic_tests, :locked, :boolean, default: false
  end
end
