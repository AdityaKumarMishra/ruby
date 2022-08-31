class ChangeOrderPurchaseMethod < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :purchase_method
    add_column :orders, :purchase_method, :int
    remove_column :purchase_items, :purchase_method
  end
end
