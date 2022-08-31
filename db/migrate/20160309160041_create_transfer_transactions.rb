class CreateTransferTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transfer_transactions do |t|
      t.datetime :payment_confirmed
      t.float :amount
      t.boolean :paid
      t.string :banking_reference

      t.timestamps null: false
    end
  end
end
