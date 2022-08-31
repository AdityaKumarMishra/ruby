class AddAttachmentAttachmentNameToEmailCustomises < ActiveRecord::Migration[6.1]
  def self.up
    change_table :email_customises do |t|
      t.attachment :attachment_name
    end
  end

  def self.down
    remove_attachment :email_customises, :attachment_name
  end
end
