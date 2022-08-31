class CreateMcqStudentAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_student_answers do |t|
      t.string :title, index: true
      t.text :description
      t.integer :time_taken
      t.references :mcq_answer, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
