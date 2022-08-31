class AddForeignKeysToTicket < ActiveRecord::Migration[6.1]
  def change
  	add_foreign_key :tickets, :users, column: :asker_id
  	add_foreign_key :tickets, :users, column: :answerer_id
  end
end
