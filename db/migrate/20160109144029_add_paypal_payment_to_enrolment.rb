class AddPaypalPaymentToEnrolment < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :paypal_payment, :string
  end
end
