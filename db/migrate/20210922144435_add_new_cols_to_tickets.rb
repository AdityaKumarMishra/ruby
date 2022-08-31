class AddNewColsToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :mark_for_resolved, :boolean, default: :false
    add_column :tickets, :start_date_for_resolved, :datetime
  end
end
