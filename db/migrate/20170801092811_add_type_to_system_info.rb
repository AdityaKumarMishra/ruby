class AddTypeToSystemInfo < ActiveRecord::Migration[6.1]
  def up
    add_column :system_infos, :product_line, :string
  end

  def down
    remove_column :system_infos, :product_line, :string
  end
end
