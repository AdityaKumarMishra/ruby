class AddRemindToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :remind, :boolean, null: false, default: false
  end
end
