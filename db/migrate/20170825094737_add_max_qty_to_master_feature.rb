class AddMaxQtyToMasterFeature < ActiveRecord::Migration[6.1]
  def change
    add_column :master_features, :max_qty, :integer
  end
end
