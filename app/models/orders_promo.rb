class OrdersPromo < ApplicationRecord
	belongs_to :promo
	belongs_to :order
end
