class CreateUnsubscribeEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :unsubscribe_emails do |t|
      t.integer :user_id
      t.boolean :unsubscribe
      t.timestamps
    end
  end
end
