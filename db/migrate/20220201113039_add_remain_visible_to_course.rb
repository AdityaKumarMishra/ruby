class AddRemainVisibleToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :remain_visible, :boolean, default: false
  end
end
