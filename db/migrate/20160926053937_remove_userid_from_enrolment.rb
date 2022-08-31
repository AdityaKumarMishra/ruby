class RemoveUseridFromEnrolment < ActiveRecord::Migration[6.1]
  def change
  	remove_column :enrolments, :user_id
  end
end
