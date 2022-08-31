class MoveAnonymousUsersToTicket < ActiveRecord::Migration[6.1]
  def up
    User.where(anonymous: true).each do |user|
      user.tickets.each do |ticket|
        ticket.first_name = user.first_name
        ticket.last_name = user.last_name
        ticket.email = user.email
        ticket.phone_number = user.phone_number
        ticket.asker = nil
        ticket.save!
      end
    end
  end

  def down
  end
end
