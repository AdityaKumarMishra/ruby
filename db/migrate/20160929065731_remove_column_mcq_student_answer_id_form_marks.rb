class RemoveColumnMcqStudentAnswerIdFormMarks < ActiveRecord::Migration[6.1]
  def change
    remove_column :marks, :mcq_student_answer_id, :integer
  end
end
