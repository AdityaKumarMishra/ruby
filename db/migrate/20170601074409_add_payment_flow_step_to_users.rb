class AddPaymentFlowStepToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :payment_flow_step, :string
  end
end
