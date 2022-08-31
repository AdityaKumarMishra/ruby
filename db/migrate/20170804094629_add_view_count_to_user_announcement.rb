class AddViewCountToUserAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :user_announcements, :view_count, :integer, default: 0
  end
end
