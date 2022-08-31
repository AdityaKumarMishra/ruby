class DeleteUserAddress < ActiveRecord::Migration[6.1]
  def change
    drop_table :user_addresses
  end
end
