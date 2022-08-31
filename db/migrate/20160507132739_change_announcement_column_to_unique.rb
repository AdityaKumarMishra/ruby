class ChangeAnnouncementColumnToUnique < ActiveRecord::Migration[6.1]
  def change
    change_column_null :announcements, :name, false
    add_index :announcements, :name, :unique => true
  end
end
