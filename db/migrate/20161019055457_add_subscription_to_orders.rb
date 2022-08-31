class AddSubscriptionToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :subscription_id, :integer
    add_column :orders, :subscription_status, :integer, default: 3, null: false
  end
end
