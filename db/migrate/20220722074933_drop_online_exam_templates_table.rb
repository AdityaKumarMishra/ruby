class DropOnlineExamTemplatesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :online_exam_templates
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
