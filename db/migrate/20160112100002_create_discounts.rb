class CreateDiscounts < ActiveRecord::Migration[6.1]
  def change
    create_table :discounts do |t|
      t.integer :enrolment_id
      t.integer :user_id
      t.boolean :ratio

      t.timestamps null: false
    end
  end
end
