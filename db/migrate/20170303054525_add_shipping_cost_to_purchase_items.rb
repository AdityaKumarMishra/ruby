class AddShippingCostToPurchaseItems < ActiveRecord::Migration[6.1]
  def change
    add_column :purchase_items, :shipping_cost, :decimal, null: false, default: 0
  end
end
