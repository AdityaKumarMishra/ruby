class AddComplaintToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :complaint, :boolean, default: false
  end
end
