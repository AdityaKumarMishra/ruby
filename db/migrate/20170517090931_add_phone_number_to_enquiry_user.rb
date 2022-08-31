class AddPhoneNumberToEnquiryUser < ActiveRecord::Migration[6.1]
  def up
    add_column :enquiry_users, :phone_number, :string
    add_column :enquiry_users, :question_tags, :text, array:true, default: []

    EnquiryUser.destroy_all
    tickets_emails = Ticket.where("asker_id IS ? AND email != ?", nil, "nil").pluck(:email)
    duplicate_emails = User.where(email: tickets_emails).pluck(:email)
    empty_users = tickets_emails - duplicate_emails
    enquiry_users = Ticket.includes(:tags).where(email: empty_users).map{|x| [x.email, x.first_name, x.last_name, x.phone_number, x.tags.pluck(:name)]}
    enquiry_users.each do |u|
      EnquiryUser.create(email: u[0], first_name: u[1], last_name: u[2], phone_number: u[3], question_tags: [u[4]])
    end


  end

  def down
    remove_column :enquiry_users, :phone_number
    remove_column :enquiry_users, :question_tags
  end
end
