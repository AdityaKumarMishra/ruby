class AddEarlyBirdToProductVersion < ActiveRecord::Migration[6.1]
  def up
  	add_column :product_versions, :early_bird, :boolean, default: false
  end
  def down
  	remove_column :product_versions, :early_bird
  end
end
