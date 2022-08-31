class AddSigninCountToEnrolment < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :signin_count_enrolment, :integer, default: 0
    add_column :enrolments, :total_online_time_enrolment, :integer, default: 0
    add_column :enrolments, :expire_signin_count, :integer, default: 0
    add_column :enrolments, :expire_total_online_time, :integer, default: 0
  end
end
