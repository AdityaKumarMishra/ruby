class AddHardcopyToEnrolment < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :online_textbook, :boolean
    add_column :enrolments, :hardcopy, :boolean
  end
end
