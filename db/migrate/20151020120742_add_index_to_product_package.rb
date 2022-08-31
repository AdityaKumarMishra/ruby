class AddIndexToProductPackage < ActiveRecord::Migration[6.1]
  def change
    add_index :product_packages, :name
    add_index :product_packages, :valid_date
    add_index :product_packages, :cost
    add_index :product_packages, :weight
  end
end
