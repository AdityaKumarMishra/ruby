class CreateMcqSets < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_sets do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
