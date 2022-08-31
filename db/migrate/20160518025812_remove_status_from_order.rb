class RemoveStatusFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :status, :string
  end
end
