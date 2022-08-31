class AddMcqQuantityToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :mcq_quantity, :integer
  end
end
