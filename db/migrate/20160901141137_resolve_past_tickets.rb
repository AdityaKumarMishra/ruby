class ResolvePastTickets < ActiveRecord::Migration[6.1]
  def up
    Ticket.includes(:ticket_answers).where.not(:ticket_answers => {:ticket_id => nil}).each do |ticket|
      ticket.update(resolved: true)
    end
  end
end
