class AddUidAndProviderToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string, default: ''
    add_column :users, :provider, :string, default: 'email'
  end
end
