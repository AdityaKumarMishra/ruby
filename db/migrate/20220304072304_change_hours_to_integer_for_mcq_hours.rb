class ChangeHoursToIntegerForMcqHours < ActiveRecord::Migration[6.1]
  def up
    change_column :mcq_hours, :hours, :float
  end

  def down
    change_column :mcq_hours, :hours, :integer
  end
end
