class CreateMcqAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_attempts do |t|
      t.references :exercise, index: true, foreign_key: true
      t.references :mcq_stem, index: true, foreign_key: true
      t.references :mcq, index: true, foreign_key: true
      t.references :mcq_answer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
