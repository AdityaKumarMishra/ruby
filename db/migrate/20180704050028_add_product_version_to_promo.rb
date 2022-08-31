class AddProductVersionToPromo < ActiveRecord::Migration[6.1]
  def up
	add_column :promos, :product_version_id, :integer
  end

  def down
    remove_column :promos, :product_version_id
  end
end
