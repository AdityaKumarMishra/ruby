class RemoveAnonymousFromUser < ActiveRecord::Migration[6.1]
  def change
  	remove_column :users, :anonymous, :boolean, default: false
  end
end
