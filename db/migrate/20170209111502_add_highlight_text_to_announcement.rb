class AddHighlightTextToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :highlighted_text, :text
  end
end
