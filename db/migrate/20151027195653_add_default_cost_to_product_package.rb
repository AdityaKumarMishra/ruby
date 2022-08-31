class AddDefaultCostToProductPackage < ActiveRecord::Migration[6.1]
  def up
    change_column_default :product_packages, :cost, 0.00
  end

  def down
    change_column_default :product_packages, :cost
  end
end
