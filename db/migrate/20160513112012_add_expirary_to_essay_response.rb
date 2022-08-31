class AddExpiraryToEssayResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_responses, :activation_date, :date
    add_column :essay_responses, :expiry_date, :date
  end
end
