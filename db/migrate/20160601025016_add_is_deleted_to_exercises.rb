class AddIsDeletedToExercises < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :is_deleted, :boolean, null: false, default: false
  end
end
