class AddEscalatedToTickets < ActiveRecord::Migration[6.1]
  def up
    add_column :tickets, :escalated, :boolean, default: false
  end

  def down
    add_column :tickets, :escalated, :boolean, default: false
  end
end
