class AddTypeColumnToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :ticket_type, :string
  end
end
