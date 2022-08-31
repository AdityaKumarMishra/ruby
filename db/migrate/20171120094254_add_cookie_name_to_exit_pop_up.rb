class AddCookieNameToExitPopUp < ActiveRecord::Migration[6.1]
  def change
    add_column :exit_pop_ups, :cookie_name, :string
  end
end
