class CreateManualEmailAnnouncementsProductVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :manual_email_announcements_product_versions do |t|
      t.integer :manual_email_announcement_id
      t.integer :product_version_id
    end
  end
end
