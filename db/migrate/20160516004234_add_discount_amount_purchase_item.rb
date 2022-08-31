class AddDiscountAmountPurchaseItem < ActiveRecord::Migration[6.1]
  def change
    add_column :purchase_items, :discount_applied, :decimal, null: false, default: 0
  end
end
