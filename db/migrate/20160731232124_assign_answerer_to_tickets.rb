class AssignAnswererToTickets < ActiveRecord::Migration[6.1]
  def up
    Ticket.where(answerer: nil).each do |ticket|
      ticket.answerer_id = 459
      ticket.asker_id = 1
      if ticket.tags.empty?
        ticket.tags = [Tag.first]
      end
      ticket.save!
    end
  end

  def down
  end
end
