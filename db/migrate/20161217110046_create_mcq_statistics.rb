class CreateMcqStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_statistics do |t|
      t.integer :total, default: 0
      t.integer :viewed, default: 0
      t.integer :correct, default: 0
      t.float :used, default: 0.0
      t.float :score, default: 0.0
      t.integer :user_id
      t.integer :tag_id
      t.integer :course_id
      t.timestamps null: false
    end
  end
end
