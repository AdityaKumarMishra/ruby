class RemoveColsFromSections < ActiveRecord::Migration[6.1]
  def change
    remove_column :sections, :time_spacing_from_last_section
    remove_column :sections, :reading_time
    remove_column :sections, :section_type_id
  end
end
