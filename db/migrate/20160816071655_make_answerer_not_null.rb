class MakeAnswererNotNull < ActiveRecord::Migration[6.1]
  def change
    # bob = User.find_by_email("bob.zhu@gradready.com.au")
    # Ticket.where(answerer: nil).update_all(answerer_id: bob.id)

    # Uncomment the following if this still fails:
    # Ticket.where(answerer: nil).destroy_all()

    change_column_null :tickets, :answerer_id, false
  end
end
