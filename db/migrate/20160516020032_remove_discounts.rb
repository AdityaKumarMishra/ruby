class RemoveDiscounts < ActiveRecord::Migration[6.1]
  def change
    drop_table "discounts", force: :cascade do |t|
      t.integer  "enrolment_id"
      t.integer  "user_id"
      t.boolean  "ratio"
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
    end
  end
end
