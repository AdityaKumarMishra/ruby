class RenameTutorApoitmentsDateToTutorAvailability < ActiveRecord::Migration[6.1]
  def change
    rename_table :tutor_apoitments_dates, :tutor_availabilities
  end
end
