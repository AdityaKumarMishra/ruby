class CreateMcqAttemptTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_attempt_times do |t|
      t.integer :mcq_stem_id
      t.integer :sectionable_id
      t.string  :sectionable_type
      t.integer :total_time, default: 0
      t.timestamps null: false
    end
  end
end
