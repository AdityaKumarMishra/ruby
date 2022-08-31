class AddFeedbackToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :feedback, :string, default: 'No'
  end
end
