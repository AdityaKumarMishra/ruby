class CreateExamSections < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_sections do |t|
      t.string :title
      t.float :dificultyRating
      t.references :exam, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
