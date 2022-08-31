class AddIsActiveToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :is_active, :boolean
  end
end
