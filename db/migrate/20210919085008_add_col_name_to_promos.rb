class AddColNameToPromos < ActiveRecord::Migration[6.1]
  def change
    add_column :promos, :name, :string
  end
end
