class DropSectionTypesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :section_types
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
