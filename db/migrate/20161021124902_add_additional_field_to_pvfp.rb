class AddAdditionalFieldToPvfp < ActiveRecord::Migration[6.1]
  def change
    add_column :product_version_feature_prices, :is_additional, :boolean, default: false
  end
end
