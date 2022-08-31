class AddDescriptionInRate < ActiveRecord::Migration[6.1]
  def change
    add_column :rates, :description, :text
  end
end
