class DropCitiesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :cities
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
