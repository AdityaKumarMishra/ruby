class AddIsActiveToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :is_active, :boolean
  end
end
