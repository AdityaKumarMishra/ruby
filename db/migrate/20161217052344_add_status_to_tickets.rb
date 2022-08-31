class AddStatusToTickets < ActiveRecord::Migration[6.1]
  def up
    # adding status column for tickets
    add_column :tickets, :status, :integer

    # transfer resolved coulmn data to status column
    Ticket.all.each do |ticket|
      ticket.update(status: ticket[:resolved] ? 0 : 1, skip_resolved_mail: true)
    end

    # removing resolved column from tickets
    remove_column :tickets, :resolved
  end

  def down
    # adding resolved column for tickets
    add_column :tickets, :resolved, :boolean

    # transfer status coulmn data to resolved column
    Ticket.all.each do |ticket|
      ticket.update(resolved: ticket[:status] == 0 ? true : false, skip_resolved_mail: true)
    end

    # removing status column for tickets
    remove_column :tickets, :status
  end
end
