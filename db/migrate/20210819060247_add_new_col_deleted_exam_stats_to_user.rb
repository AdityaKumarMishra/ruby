class AddNewColDeletedExamStatsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stats_deleted_at, :date, default: Date.today
  end
end
