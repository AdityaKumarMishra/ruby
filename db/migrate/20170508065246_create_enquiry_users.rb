class CreateEnquiryUsers < ActiveRecord::Migration[6.1]
  def up
    create_table :enquiry_users do |t|

      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end

    tickets_emails = Ticket.where("asker_id IS ? AND email != ?", nil, "nil").pluck(:email)
    duplicate_emails = User.where(email: tickets_emails).pluck(:email)
    empty_users = tickets_emails - duplicate_emails
    enquiry_users = Ticket.where(email: empty_users).pluck(:email, :first_name, :last_name)
    enquiry_users.each do |u|
      EnquiryUser.create(email: u[0], first_name: u[1], last_name: u[2])
    end
  end

  def down
    drop_table :enquiry_users
  end
end
