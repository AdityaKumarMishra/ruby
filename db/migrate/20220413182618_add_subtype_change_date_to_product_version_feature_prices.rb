class AddSubtypeChangeDateToProductVersionFeaturePrices < ActiveRecord::Migration[6.1]
  def change
    add_column :product_version_feature_prices, :subtype_change_date, :datetime
  end
end
