class AddFieldsToMcqStat < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_statistics, :incorrect, :integer, default: 0
    add_column :mcq_statistics, :correct_per, :float, default: 0.0
  end
end
