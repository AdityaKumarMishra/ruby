class AddFollowUpDateToTickets < ActiveRecord::Migration[6.1]
  def change
  	add_column :tickets, :follow_up_date, :datetime
  end
end
