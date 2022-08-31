class AddForPaidForTrialToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :for_paid, :boolean
    add_column :documents, :for_trial, :boolean
  end
end
