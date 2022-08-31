class AddReadCountToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :read_count, :integer, default: 0
    add_column :download_hit_counters, :estimated_read_time, :integer, default: 0
  end
end
