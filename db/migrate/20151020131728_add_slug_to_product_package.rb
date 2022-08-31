class AddSlugToProductPackage < ActiveRecord::Migration[6.1]
  def change
    add_column :product_packages, :slug, :string
  end
end
