class CreateMarks < ActiveRecord::Migration[6.1]
  def change
    create_table :marks do |t|
      t.float :value
      t.boolean :correct
      t.references :user, index: true, foreign_key: true
      t.references :essay_response, index: true, foreign_key: true
      t.references :mcq_student_answer, index: true, foreign_key: true
      t.string :description

      t.timestamps null: false
    end
  end
end
