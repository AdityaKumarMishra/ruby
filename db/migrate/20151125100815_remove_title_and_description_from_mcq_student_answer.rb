class RemoveTitleAndDescriptionFromMcqStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :mcq_student_answers, :title, :string
    remove_column :mcq_student_answers, :description, :string
  end
end
