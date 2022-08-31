class DeleteSelectedFromMcqStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :mcq_student_answers, :selected
  end
end
