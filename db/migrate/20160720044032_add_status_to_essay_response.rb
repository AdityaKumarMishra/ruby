class AddStatusToEssayResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_responses, :status, :integer, default: 0
  end
end
