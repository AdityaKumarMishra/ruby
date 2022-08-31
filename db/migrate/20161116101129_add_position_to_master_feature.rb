class AddPositionToMasterFeature < ActiveRecord::Migration[6.1]
  def change
    add_column :master_features, :position, :integer
  end
end
