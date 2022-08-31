class AddColumnStateToEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :state, :integer, default: 0
  end
end
