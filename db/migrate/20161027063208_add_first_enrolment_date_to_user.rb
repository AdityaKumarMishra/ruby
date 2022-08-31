class AddFirstEnrolmentDateToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_enrolment_date, :date
  end
end
