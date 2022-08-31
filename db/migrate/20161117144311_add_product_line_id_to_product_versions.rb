class AddProductLineIdToProductVersions < ActiveRecord::Migration[6.1]
  def change
    add_reference :product_versions, :product_line, index: true, foreign_key: true
  end
end
