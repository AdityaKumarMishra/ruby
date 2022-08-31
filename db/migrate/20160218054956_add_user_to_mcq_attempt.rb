class AddUserToMcqAttempt < ActiveRecord::Migration[6.1]
  def change
    add_reference :mcq_attempts, :user, index: true, foreign_key: true
  end
end
