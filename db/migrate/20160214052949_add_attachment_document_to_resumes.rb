class AddAttachmentDocumentToResumes < ActiveRecord::Migration[6.1]
  def self.up
    change_table :resumes do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :resumes, :document
  end
end
