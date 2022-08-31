class AddNewColsToManualEmailAnnouncement < ActiveRecord::Migration[6.1]
  def self.up
    change_table :manual_email_announcements do |t|
      t.attachment :first_docuemnt
      t.attachment :second_docuemnt
      t.attachment :third_docuemnt
    end
  end

  def self.down
    remove_attachment :manual_email_announcements, :first_docuemnt
    remove_attachment :manual_email_announcements, :second_docuemnt
    remove_attachment :manual_email_announcements, :third_docuemnt
  end
end
