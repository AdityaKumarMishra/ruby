class AddTrialColumnsToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :trial_enabled, :boolean, default: false
    add_column :courses, :trial_period_days, :integer, default: 0
  end
end
