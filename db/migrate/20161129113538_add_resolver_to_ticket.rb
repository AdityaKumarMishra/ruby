class AddResolverToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :resolver_id, :integer
  end
end
