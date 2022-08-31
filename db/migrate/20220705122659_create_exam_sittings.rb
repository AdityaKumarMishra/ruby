class CreateExamSittings < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_sittings do |t|
      t.string :name
      t.datetime :start_time
      t.integer :exam_setting_type
      t.integer :online_exam_id, index: true
      t.timestamps
    end
  end
end
