class CreateLastMinCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :last_min_courses do |t|

      t.timestamps null: false

      t.string :course_name
      t.string :date
      t.integer :amount
      t.text :description
      t.integer :course_type
    end
  end
end
