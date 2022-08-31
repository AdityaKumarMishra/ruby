class AddArchivedToCourses < ActiveRecord::Migration[6.1]
  def up
    add_column :courses, :show_archived, :boolean, default: false

  end

  def down
    remove_column :courses, :show_archived, :boolean
  end
end
