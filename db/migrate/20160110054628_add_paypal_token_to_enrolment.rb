class AddPaypalTokenToEnrolment < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :paypal_token, :string
  end
end
