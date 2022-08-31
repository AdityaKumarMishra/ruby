class AddTransferDataFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :data_transferred, :boolean, default: false
    add_column :users, :essay_transferred, :boolean, default: false
  end
end
