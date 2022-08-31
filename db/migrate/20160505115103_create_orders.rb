class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :reference_number
      t.decimal :redundant_total_cost, precision: 8, scale: 2
      t.decimal :redundant_method_fee, precision: 8, scale: 2
      t.string :status
      t.string :brain_tree_reference
      t.datetime :paid_at
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
