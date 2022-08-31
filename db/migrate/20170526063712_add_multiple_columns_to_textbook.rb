
class AddMultipleColumnsToTextbook < ActiveRecord::Migration[6.1]
  def up
    add_column :textbooks, :for_textbook, :boolean
    add_column :textbooks, :for_textbook_slide, :boolean
    add_column :textbooks, :for_live_handout, :boolean
    add_column :textbooks, :for_live_slide, :boolean
    add_column :textbooks, :for_document, :boolean
    add_column :textbooks, :for_timetable, :boolean
    add_column :textbooks, :product_line_id, :integer
    add_column :textbooks, :user_id, :integer
  end

  def down
    remove_column :textbooks, :for_textbook
    remove_column :textbooks, :for_textbook_slide
    remove_column :textbooks, :for_live_handout
    remove_column :textbooks, :for_live_slide
    remove_column :textbooks, :for_document
    remove_column :textbooks, :for_timetable
    remove_column :textbooks, :product_line_id
    remove_column :textbooks, :user_id
  end
end

