class CreateStudentQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :student_questions do |t|
      t.text :question
      t.datetime :date_published, index: true
      t.boolean :published
      t.references :user, index: true, foreign_key: true
      t.references :tutor_answer, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
