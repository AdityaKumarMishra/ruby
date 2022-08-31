class AddNewColenumDisplayTypeToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :display_type, :integer, default: 0
  end
end
