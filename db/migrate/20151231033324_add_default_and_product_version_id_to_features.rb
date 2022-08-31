class AddDefaultAndProductVersionIdToFeatures < ActiveRecord::Migration[6.1]
  def change
    add_column :features, :is_default, :boolean
    add_column :features, :product_version_id, :integer
  end
end
