class AddGivenTypeToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :given_type, :string
    add_column :tickets, :given_id, :integer
  end
end
