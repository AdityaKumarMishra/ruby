class AddNewFieldsToSections < ActiveRecord::Migration[6.1]
  def change
    add_column :sections, :time_spacing_from_last_section, :integer
    add_column :sections, :reading_time, :integer
    add_column :sections, :section_type_id, :integer, index: true
  end
end
