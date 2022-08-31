class AddPositionToMcq < ActiveRecord::Migration[6.1]
  def change
  	add_column :mcqs, :position, :integer
  end
end
