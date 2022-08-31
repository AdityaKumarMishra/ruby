class AddSubtypeToProductVersionFeaturePrices < ActiveRecord::Migration[6.1]
  def up
  	add_column :product_version_feature_prices, :subtype, :integer
  end

  def down
  	remove_column :product_version_feature_prices, :subtype
  end
end
