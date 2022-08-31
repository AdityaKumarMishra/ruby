class CreateLostTicketsUser < ActiveRecord::Migration[6.1]
  def up
    User.create!(
      email: "lost.tickets@gradready.com.au",
      username: "lost.tickets",
      first_name: "Lost",
      last_name: "Tickets",
      bio: "Lost tickets go to me.",
      password: Devise.friendly_token
    )
  end

  def down
  end
end
