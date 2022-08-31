class CreateMcqHours < ActiveRecord::Migration[6.1]
  def change
    drop_table(:mcq_hours, if_exists: true)
    create_table :mcq_hours do |t|
      t.belongs_to :user
      t.belongs_to :mcq_stem
      t.integer :logging_type
      t.integer :hours, default: 0
      t.timestamps
    end
  end
end
