class AddFeatureLogIsToAppointment < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :feature_log_id, :integer
  end
end
