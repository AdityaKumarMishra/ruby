class RemoveUserIdAndMcqIdFromSectionItemAttempts < ActiveRecord::Migration[6.1]
  def change
    remove_column :section_item_attempts, :user_id, :integer
    remove_column :section_item_attempts, :mcq_id, :integer
  end
end
