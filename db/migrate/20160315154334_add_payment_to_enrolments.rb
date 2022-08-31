class AddPaymentToEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :subtotal, :float
    add_column :enrolments, :gst, :float
    add_column :enrolments, :paypal_fee, :float
  end
end
