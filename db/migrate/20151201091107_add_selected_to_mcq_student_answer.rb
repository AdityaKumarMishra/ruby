class AddSelectedToMcqStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_student_answers, :selected, :boolean, default: false
  end
end
