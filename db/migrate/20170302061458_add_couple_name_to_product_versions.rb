class AddCoupleNameToProductVersions < ActiveRecord::Migration[6.1]
  def up
    # adding couple name to product_versions
    add_column :product_versions, :couple_name, :string

    # transfer original name to couple name
    ProductVersion.update_all("couple_name=name")

  end

  def down
    remove_column :product_versions, :couple_name, :string
  end
end
