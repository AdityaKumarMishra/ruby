class AddPreviousStateBeforeUnenrolledToEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :previous_state_before_unenrolled, :string
  end
end
