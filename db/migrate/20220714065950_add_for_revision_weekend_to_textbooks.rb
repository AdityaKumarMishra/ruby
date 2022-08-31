class AddForRevisionWeekendToTextbooks < ActiveRecord::Migration[6.1]
  def change
    add_column :textbooks, :for_revision_weekend, :boolean, deafult: false
    add_column :textbooks, :for_mock_exam, :boolean, deafult: false
  end
end
