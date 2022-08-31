class CreateProductVersionFeaturePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :product_version_feature_prices do |t|
      t.references :product_version, index: true
      t.references :master_feature, index: true
      t.float :price
      t.integer :qty
      t.boolean :is_default
      t.timestamps null: false
    end
  end
end
