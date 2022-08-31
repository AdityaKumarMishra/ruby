class AddSessionTimeToFeatures < ActiveRecord::Migration[6.1]
  def change
    add_column :features, :tutor_time, :integer
  end
end
