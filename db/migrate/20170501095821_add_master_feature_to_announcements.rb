class AddMasterFeatureToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    remove_column :announcements, :product
    add_column :announcements, :master_feature_id, :integer
    add_column :announcements, :product_line_id, :integer
  end
end
