class AddTypeToLessons < ActiveRecord::Migration[6.1]
  def up
    add_column :lessons, :lesson_type, :integer
  end

  def down
    remove_column :lessons, :lesson_type, :integer
  end
end
