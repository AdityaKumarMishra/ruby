class DropCitiesExamSittingsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :cities_exam_sittings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
