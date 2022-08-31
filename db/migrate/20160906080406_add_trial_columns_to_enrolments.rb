class AddTrialColumnsToEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :trial, :boolean, null: false, default: false
    add_column :enrolments, :trial_expiry, :datetime
  end
end
