class AddAccessLimitAndFeatureAccessCount < ActiveRecord::Migration[6.1]
  def change
    add_column :users,  :feature_access_count, :integer, default: 0
    add_column :product_version_feature_prices, :access_limit, :integer
  end
end
