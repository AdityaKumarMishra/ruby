class AddSlugToMcqStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_student_answers, :slug, :string
    add_index :mcq_student_answers, :slug, unique: true
  end
end
