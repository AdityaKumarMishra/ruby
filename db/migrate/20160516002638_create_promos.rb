class CreatePromos < ActiveRecord::Migration[6.1]
  def change
    create_table :promos do |t|
      t.string :token, index: { unique: true }
      t.boolean :stackable, null: false, default: false

      t.integer :strategy, null: false, default: 0
      t.decimal :amount, null: false, default: 0

      t.references :user, index: true, foreign_key: true
      t.references :purchasable, polymorphic: true

      t.timestamps null: false
    end
  end
end
