class CreateMailPendings < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_pendings do |t|
      t.integer :user_id
      t.integer :order_id
      t.integer :enrolment_id
      t.string :category
      t.string :method
      t.integer :status
      t.timestamps null: false
    end
  end
end
