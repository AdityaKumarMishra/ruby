class CreateMcqStemCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_stem_courses do |t|
      t.references :mcq_stem, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
