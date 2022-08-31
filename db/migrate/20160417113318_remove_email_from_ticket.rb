class RemoveEmailFromTicket < ActiveRecord::Migration[6.1]
  def change
    # remove_column :tickets, :email
    change_column :tickets, :public, :boolean, default: false, null: false
  end
end
