class CreateEmailDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :email_deliveries do |t|
      t.string :recipient
      t.string :from
      t.string :subject
      t.string :category
      t.string :trigger_name
      t.string :body
      t.timestamps null: false
    end
  end
end
