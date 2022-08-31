class CreateEssaysEssays < ActiveRecord::Migration[6.1]
  def change
    create_table :essays do |t|
      t.string :title
      t.text :question
      t.datetime :date_added
      t.datetime :expiration_date
      t.references :tutor, index: true
      t.references :student, index: true

      t.timestamps null: false
    end
  end
end
