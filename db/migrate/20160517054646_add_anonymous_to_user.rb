class AddAnonymousToUser < ActiveRecord::Migration[6.1]
  def change
    # Allow users to be anonymous
    add_column :users, :anonymous, :boolean, default: false
  end
end
