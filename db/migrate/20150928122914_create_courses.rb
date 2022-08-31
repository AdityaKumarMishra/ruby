class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :class_size
      t.integer :student_count
      t.date :expiry_date
      t.datetime :enrolment_end_date
      t.integer :product_version_id

      t.timestamps null: false
    end
  end
end
