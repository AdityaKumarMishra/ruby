class AddIndexToExam < ActiveRecord::Migration[6.1]
  def change
    add_index :exams, :date_started
    add_index :exams, :date_finished
  end
end
