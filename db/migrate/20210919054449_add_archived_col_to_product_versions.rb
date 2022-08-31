class AddArchivedColToProductVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :product_versions, :archived, :boolean, deafult: :false
  end
end
