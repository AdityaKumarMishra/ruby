class AddEssayTimeToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :essay_time, :integer, default: 120
  end
end
