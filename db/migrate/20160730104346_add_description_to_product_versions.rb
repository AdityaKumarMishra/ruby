class AddDescriptionToProductVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :product_versions, :description, :text, null: false, default: ""
  end
end
