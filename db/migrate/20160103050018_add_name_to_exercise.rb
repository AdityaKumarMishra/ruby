class AddNameToExercise < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :name, :string
  end
end
