class AddFreemiumToProductVersion < ActiveRecord::Migration[6.1]
  def change
    add_column :product_versions, :freemium, :boolean, default: false
  end
end
