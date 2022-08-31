class DropCoursesExamSittingsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :courses_exam_sittings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
