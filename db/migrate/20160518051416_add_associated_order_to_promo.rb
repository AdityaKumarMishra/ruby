class AddAssociatedOrderToPromo < ActiveRecord::Migration[6.1]
  def change
    add_reference :promos, :generated_from, index: true, references: :orders
    add_foreign_key :promos, :users, column: :generated_from_id
  end
end
