class ChangeInExitPopup < ActiveRecord::Migration[6.1]
  def change
    remove_column :exit_pop_ups, :product_line_id
    remove_column :exit_pop_ups, :url
    add_column :exit_pop_ups, :popup_frequency, :integer, default: 0
  end
end
