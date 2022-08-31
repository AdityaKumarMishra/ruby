class CreateExercises < ActiveRecord::Migration[6.1]
  def change
    create_table :exercises do |t|
      t.integer :difficulty
      t.integer :amount
      t.datetime :completed_at
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
