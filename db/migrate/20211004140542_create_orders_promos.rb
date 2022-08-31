class CreateOrdersPromos < ActiveRecord::Migration[6.1]
	def change
	    # Create a new table with id and timestamps to replace the old one
	    rename_table :orders_promos, :orders_promos_old
	    create_table :orders_promos do |t|
	      t.belongs_to :order
	      t.belongs_to :promo
	      t.timestamps
	    end

	    # Now populate it with a SQL one-liner!
	    execute "insert into orders_promos(order_id,promo_id) select order_id,promo_id from orders_promos_old"

	    # drop the old table
	    #drop_table :orders_promos_old
	end
end
