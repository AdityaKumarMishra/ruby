class AddActivatePaypalToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :activate_paypal, :boolean, default: false
  end
end
