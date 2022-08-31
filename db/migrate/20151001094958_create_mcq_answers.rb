class CreateMcqAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_answers do |t|
      t.text :answer
      t.boolean :correct
      t.text :explanation
      t.integer :time_taken
      t.references :mcq, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
