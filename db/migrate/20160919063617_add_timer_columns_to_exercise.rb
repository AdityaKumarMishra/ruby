class AddTimerColumnsToExercise < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :timer_option, :string, default: 'no_timer'
    add_column :exercises, :overall_time, :integer
  end
end
