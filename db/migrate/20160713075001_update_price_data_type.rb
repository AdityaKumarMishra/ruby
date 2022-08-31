class UpdatePriceDataType < ActiveRecord::Migration[6.1]
  def up
    change_column :features, :price, :decimal, precision: 8, scale: 2
    change_column :product_versions, :price, :decimal, precision: 8, scale: 2
  end

  def down
    change_column :features, :price, :float
    change_column :product_versions, :price, :float

  end
end
