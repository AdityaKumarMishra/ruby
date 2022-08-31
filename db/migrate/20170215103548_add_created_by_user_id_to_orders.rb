class AddCreatedByUserIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :creator, index: true
  end
end
