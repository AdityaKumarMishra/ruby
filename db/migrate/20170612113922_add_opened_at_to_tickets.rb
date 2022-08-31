class AddOpenedAtToTickets < ActiveRecord::Migration[6.1]
  def up
    add_column :tickets, :opened_at, :datetime

    Ticket.all.each do |ticket|
      ticket.update_attribute(:opened_at, ticket.created_at)
     end
  end

  def down
    remove_column :tickets, :opened_at
  end

end
