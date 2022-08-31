class CreateStudentClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :student_classes do |t|
      t.string :name
      t.integer :size
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :user_student_classes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :student_class, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
