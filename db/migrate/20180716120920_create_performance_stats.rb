class CreatePerformanceStats < ActiveRecord::Migration[6.1]
  def change
    create_table :performance_stats do |t|
      t.references :user, index: true, null: false
      t.references :tag, index: true, null: false
      t.references :performable, polymorphic: true, index: true, null: false
      t.integer :unit_completed, default: 0

      t.timestamps null: false
    end
  end
end
