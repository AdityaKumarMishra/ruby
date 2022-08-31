class AddNewColDiscountNameToPurchaseItems < ActiveRecord::Migration[6.1]
  def change
    add_column :purchase_items, :discount_name, :string
  end
end
