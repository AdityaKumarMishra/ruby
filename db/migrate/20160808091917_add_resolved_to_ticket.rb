class AddResolvedToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :resolved, :boolean, null: false, default: false
  end
end
