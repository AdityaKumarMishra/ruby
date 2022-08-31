class AddPositionToEssays < ActiveRecord::Migration[6.1]
  def change
    add_column :essays, :position, :integer
  end
end
