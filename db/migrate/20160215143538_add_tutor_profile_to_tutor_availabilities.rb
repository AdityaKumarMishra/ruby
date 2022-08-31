class AddTutorProfileToTutorAvailabilities < ActiveRecord::Migration[6.1]
  def change
    add_reference :tutor_availabilities, :tutor_profile, index: true, foreign_key: true
  end
end
