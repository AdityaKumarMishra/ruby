class CreatePurchaseItems < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_items do |t|
      t.decimal :initial_cost, precision: 8, scale: 2
      t.decimal :added_gst, precision: 8, scale: 2
      t.decimal :method_fee, precision: 8, scale: 2
      t.string :purchase_description
      t.string :purchase_method
      t.references :order, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :purchasable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
