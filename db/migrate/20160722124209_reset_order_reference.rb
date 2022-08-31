class ResetOrderReference < ActiveRecord::Migration[6.1]
  def up
    Order.where("status = ?",0).each do |order|
      order.reference_number = rand(36**6).to_s(36)
      order.save
    end

  end

  def down

  end
end
