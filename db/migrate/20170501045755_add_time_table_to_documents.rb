class AddTimeTableToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :for_timetable, :boolean
    add_column :documents, :product_line_id, :integer
  end
end
