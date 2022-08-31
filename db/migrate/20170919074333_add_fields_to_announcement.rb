class AddFieldsToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :story, :text
    add_column :announcements, :display_name, :string
    add_attachment :announcements, :video
  end
end
