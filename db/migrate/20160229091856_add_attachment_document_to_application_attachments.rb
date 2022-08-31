class AddAttachmentDocumentToApplicationAttachments < ActiveRecord::Migration[6.1]
  def self.up
    change_table :application_attachments do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :application_attachments, :document
  end
end
