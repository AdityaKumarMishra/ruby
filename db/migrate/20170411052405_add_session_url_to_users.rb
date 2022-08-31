class AddSessionUrlToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :session_url, :string
  end

  def down
    remove_column :users, :session_url, :string
  end
end
