class DeleteHelpfulness < ActiveRecord::Migration[6.1]
  def change
	remove_column :ticket_answers, :helpfulness, :integer
  end
end
