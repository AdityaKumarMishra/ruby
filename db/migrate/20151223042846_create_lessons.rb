class CreateLessons < ActiveRecord::Migration[6.1]
  def change
    create_table :lessons do |t|
      t.date :date
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.string :item_covered
      t.integer :course_id

      t.timestamps null: false
    end
  end
end