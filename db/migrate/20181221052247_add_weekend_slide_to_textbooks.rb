class AddWeekendSlideToTextbooks < ActiveRecord::Migration[6.1]
  def up
    add_column :textbooks, :for_weekend, :boolean, default: false
  end

  def down
    remove_column :textbooks, :for_weekend
  end
end
