class AddIndexesToProduct < ActiveRecord::Migration[6.1]
  def change
    add_index :products, :sku
    add_index :products, :name
    add_index :products, :cost
    add_index :products, :weight
    add_index :products, :length
    add_index :products, :height
    add_index :products, :starting_date
    add_index :products, :stopping_date
  end
end
