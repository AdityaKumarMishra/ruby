class CreateApplicationAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :application_attachments do |t|
      t.integer :job_application_id

      t.timestamps null: false
    end
  end
end
