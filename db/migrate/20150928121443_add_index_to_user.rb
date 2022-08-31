class AddIndexToUser < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :username
    add_index :users, :date_of_birth
    add_index :users, :date_signed_up
  end
end
