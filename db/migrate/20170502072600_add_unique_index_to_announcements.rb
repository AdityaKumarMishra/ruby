class AddUniqueIndexToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    add_index :announcements, [:product_line_id, :master_feature_id], unique: true
  end
end
