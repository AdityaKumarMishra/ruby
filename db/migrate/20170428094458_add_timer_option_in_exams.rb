class AddTimerOptionInExams < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :timer_option_type, :string
    add_column :assessment_attempts, :timer_option_type, :string
  end
end
