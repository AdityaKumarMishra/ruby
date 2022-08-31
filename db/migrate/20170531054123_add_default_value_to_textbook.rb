class AddDefaultValueToTextbook < ActiveRecord::Migration[6.1]
  def up
    change_column :textbooks, :for_textbook, :boolean, default: false
    change_column :textbooks, :for_textbook_slide, :boolean, default: false
    change_column :textbooks, :for_live_handout, :boolean, default: false
    change_column :textbooks, :for_live_slide, :boolean, default: false
    change_column :textbooks, :for_document, :boolean, default: false
    change_column :textbooks, :for_timetable, :boolean, default: false
  end

  def down
    change_column :textbooks, :for_textbook, :boolean, default: nil
    change_column :textbooks, :for_textbook_slide, :boolean, default: nil
    change_column :textbooks, :for_live_handout, :boolean, default: nil
    change_column :textbooks, :for_live_slide, :boolean, default: nil
    change_column :textbooks, :for_document, :boolean, default: nil
    change_column :textbooks, :for_timetable, :boolean, default: nil
  end
end
