class CreateMcqs < ActiveRecord::Migration[6.1]
  def change
    create_table :mcqs do |t|
      t.text :question
      t.float :difficulty
      t.boolean :examinable
      t.boolean :publish

      t.timestamps null: false
    end
  end
end
