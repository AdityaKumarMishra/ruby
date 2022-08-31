class MakeUserEmailsNotUnique < ActiveRecord::Migration[6.1]
  def change
    # Remove unique constraint from email
    remove_index :users, :email
    add_index :users, :email, unique: false
  end
end
