class RemoveColumnUserIdFromSectionAttempts < ActiveRecord::Migration[6.1]
  def change
    remove_column :section_attempts, :user_id, :integer
  end
end
