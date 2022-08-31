class AddUsedTimesToPromo < ActiveRecord::Migration[6.1]
  def change
    add_column :promos, :used_times, :integer, default: 1
  end
end
