class AddSlugToProductVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :product_versions, :slug, :string
    add_index :product_versions, :slug, unique: true
  end
end
