class CreateManualEmailAnnouncementsMasterFeatures < ActiveRecord::Migration[6.1]
  def change
    create_table :manual_email_announcements_master_features do |t|
      t.integer :manual_email_announcement_id
      t.integer :master_feature_id
    end
  end
end
