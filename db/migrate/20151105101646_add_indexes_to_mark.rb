class AddIndexesToMark < ActiveRecord::Migration[6.1]
  def change
    add_index :marks, :value
    add_index :marks, :description
  end
end
