class CreateNewCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :new_courses do |t|
      t.string :name
      t.integer :class_size
      t.integer :students_count
      t.datetime :enrolment_end
      t.date :expiry_date
      t.integer :product_version_id

      t.timestamps null: false
    end
  end
end