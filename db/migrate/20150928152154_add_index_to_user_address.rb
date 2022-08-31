class AddIndexToUserAddress < ActiveRecord::Migration[6.1]
  def change
    add_index :user_addresses, :street_name
    add_index :user_addresses, :street_type
    add_index :user_addresses, :subburb
    add_index :user_addresses, :city
    add_index :user_addresses, :state
  end
end
