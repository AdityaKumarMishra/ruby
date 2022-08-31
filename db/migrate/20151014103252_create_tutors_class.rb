class CreateTutorsClass < ActiveRecord::Migration[6.1]
  def change
    create_table :tutors_classes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :student_class, index: true, foreign_key: true
    end
  end
end
