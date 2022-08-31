class AddingFieldsToTicket < ActiveRecord::Migration[6.1]
  def change
  	add_column :tickets, :email, :string
  	add_column :tickets, :phone_number, :string
  	add_column :tickets, :first_name, :string
  	add_column :tickets, :last_name, :string
  end
end
