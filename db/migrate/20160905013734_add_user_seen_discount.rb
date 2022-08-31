class AddUserSeenDiscount < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :seen_discount_popup, :boolean, default: false, null: false
  end
end
