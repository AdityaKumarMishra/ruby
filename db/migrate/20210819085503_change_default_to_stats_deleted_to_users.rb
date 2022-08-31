class ChangeDefaultToStatsDeletedToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :stats_deleted_at, :date, default: Date.today - 1
  end
end
