class CreateStudentClassSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :student_class_sessions do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :frequency
      t.references :student_class, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
