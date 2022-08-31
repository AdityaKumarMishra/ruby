class AddCourseToTransferTransactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :transfer_transactions, :course, index: true, foreign_key: true
  end
end
