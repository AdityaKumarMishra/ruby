class AddAttributesToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :date_signed_up, :datetime
    add_column :users, :role, :string
    add_column :users, :bio, :text
    add_column :users, :profile_image, :string    
  end
end
