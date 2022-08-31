class DropExamSittingsProductVersionsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :exam_sittings_product_versions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
