class UndoMistakeToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :product_versions, :announcement_id, :integer
    remove_column :announcements, :announcement_id
  end
end
