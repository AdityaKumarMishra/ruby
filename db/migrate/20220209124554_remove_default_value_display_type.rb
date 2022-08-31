class RemoveDefaultValueDisplayType < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:mcqs, :display_type, from: 0, to: nil)
  end
end
