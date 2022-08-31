class CreateActiveSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :active_subjects do |t|
      t.references :subject, index: true, foreign_key: true
      t.references :course_version, index: true, foreign_key: true

      t.timestamps null: false
    end

    remove_reference :subjects, :course_version
    remove_reference :user_subjects, :subject
    remove_reference :student_classes, :subject
    add_reference :student_classes, :active_subject, index: true, foreign_key: true
    add_reference :user_subjects, :active_subject, index: true, foreign_key: true
  end
end
