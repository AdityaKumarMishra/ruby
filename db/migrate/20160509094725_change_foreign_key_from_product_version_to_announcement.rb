class ChangeForeignKeyFromProductVersionToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :product_version_id, :integer
    remove_column :product_versions, :announcement_id
  end
end
