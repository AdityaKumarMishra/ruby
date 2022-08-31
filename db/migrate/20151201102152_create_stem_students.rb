class CreateStemStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :stem_students do |t|
      t.integer :time_left
      t.text :description
      t.string :title
      t.string :mcqs

      t.timestamps null: false
    end
  end
end
