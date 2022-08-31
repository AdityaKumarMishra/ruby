class AddAttachmentDocumentToOnlineExams < ActiveRecord::Migration[6.1]
  def self.up
    change_table :online_exams do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :online_exams, :document
  end
end
