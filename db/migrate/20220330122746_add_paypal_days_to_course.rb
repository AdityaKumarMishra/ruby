class AddPaypalDaysToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :paypal_days, :integer , default: 3
  end
end
