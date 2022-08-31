class AddShowHighButtonAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :show_highlight, :boolean, default: true
  end
end
