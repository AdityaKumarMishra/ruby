class UpdateUniqueOrderNumber < ActiveRecord::Migration[6.1]
  def up
    Order.where("status = ?",0).each do |order|
      order.set_reference_number
    end

  end

  def down

  end
end
