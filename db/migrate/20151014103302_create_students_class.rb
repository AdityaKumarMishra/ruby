class CreateStudentsClass < ActiveRecord::Migration[6.1]
  def change
    create_table :students_classes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :student_class, index: true, foreign_key: true
    end

    drop_table :user_student_classes
  end
end
