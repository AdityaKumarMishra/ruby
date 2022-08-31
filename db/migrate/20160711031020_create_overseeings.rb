class CreateOverseeings < ActiveRecord::Migration[6.1]
  def change
    create_table :overseeings do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
