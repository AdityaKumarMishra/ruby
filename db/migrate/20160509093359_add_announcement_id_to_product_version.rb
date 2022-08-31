class AddAnnouncementIdToProductVersion < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :announcement_id, :integer
  end
end
