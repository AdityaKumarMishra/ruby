class AddColumnToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :url, :string
  end
end
