class CreateProductVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :product_versions do |t|
      t.string :name
      t.float :price
      t.string :type

      t.timestamps null: false
    end
  end
end
