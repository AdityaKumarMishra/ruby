class AddAttributesToMasterFeature < ActiveRecord::Migration[6.1]
  def change
    add_column :master_features, :url, :string
    add_column :master_features, :title, :string
    add_column :master_features, :icon, :string
    add_column :master_features, :show_in_sidebar, :boolean
    add_column :master_features, :model_permissions, :string, array: true, default: []
    add_column :master_features, :default_state, :string
  end
end
