class AddPurchaseMethodToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :purchase_method, :string
  end
end
