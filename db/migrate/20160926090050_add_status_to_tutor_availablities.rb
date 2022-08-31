class AddStatusToTutorAvailablities < ActiveRecord::Migration[6.1]
  def change
    add_column :tutor_availabilities, :status, :integer, default: 0, null: false
  end
end
