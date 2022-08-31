class CreateTextbookDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :textbook_deliveries do |t|
    	t.belongs_to :user, index: true
      t.belongs_to :enrolment, index: true
      t.belongs_to :order, index: true
      t.integer :status, default: 0
      t.datetime :date_sent
      t.boolean :priority, default: false
      t.string :tracking_number, unique: true
      t.boolean :temporary_access_granted, default: false
      t.timestamps null: false
    end
  end
end
