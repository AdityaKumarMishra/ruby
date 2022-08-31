class RemoveDetailsFromTutorAvailability < ActiveRecord::Migration[6.1]
  def change
    remove_column :tutor_availabilities, :user_id, :integer
  end
end
