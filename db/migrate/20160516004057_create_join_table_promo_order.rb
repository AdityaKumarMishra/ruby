class CreateJoinTablePromoOrder < ActiveRecord::Migration[6.1]
  def change
    create_join_table :promos, :orders do |t|
      t.index [:promo_id, :order_id]
      t.index [:order_id, :promo_id]
    end
  end
end
