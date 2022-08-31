class AddAttachmentDocumentToJobDescriptions < ActiveRecord::Migration[6.1]
  def self.up
    change_table :job_descriptions do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :job_descriptions, :document
  end
end
