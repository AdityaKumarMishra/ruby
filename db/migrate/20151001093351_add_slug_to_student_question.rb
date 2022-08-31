class AddSlugToStudentQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :student_questions, :slug, :string
    add_index :student_questions, :slug, unique: true
  end
end
