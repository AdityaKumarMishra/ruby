class AddProductLineIdToMasterFeatures < ActiveRecord::Migration[6.1]
  def change
    add_reference :master_features, :product_line, index: true, foreign_key: true
  end
end
