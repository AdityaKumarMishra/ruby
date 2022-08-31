class AddCommentToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :comment, :string
  end
end
