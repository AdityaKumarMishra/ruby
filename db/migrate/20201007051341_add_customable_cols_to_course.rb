class AddCustomableColsToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :customable, :boolean, default: false
  end
end
