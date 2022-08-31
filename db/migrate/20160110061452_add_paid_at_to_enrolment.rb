class AddPaidAtToEnrolment < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :paid_at, :datetime
  end
end
