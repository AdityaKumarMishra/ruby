class CreatePurchaseAddons < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_addons do |t|
      t.datetime :paid_at
      t.datetime :date_activated
      t.datetime :date_deactivated
      t.text :features
      t.float :subtotal
      t.float :gst
      t.float :paypal_fee
      t.string :paypal_payment
      t.string :paypal_token
      t.string :banktrans
      t.boolean :paypal
      t.boolean :bank

      t.timestamps null: false
    end
  end
end
