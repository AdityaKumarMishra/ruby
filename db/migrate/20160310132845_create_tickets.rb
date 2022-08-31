class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :question
      t.references :asker, references: :users, index: true
      t.references :answerer, references: :users, index: true
      t.boolean :public
      t.datetime :answered_at
      t.references :questionable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
