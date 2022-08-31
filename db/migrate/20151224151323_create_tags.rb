class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.integer :tagging_count
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
