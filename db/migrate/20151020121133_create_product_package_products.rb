class CreateProductPackageProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :product_package_products do |t|
      t.references :product_package, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
