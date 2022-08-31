class CreateEnrolments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrolments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :new_course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
