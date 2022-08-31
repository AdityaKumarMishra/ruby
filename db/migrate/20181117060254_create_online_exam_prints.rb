class CreateOnlineExamPrints < ActiveRecord::Migration[6.1]
  def change
    create_table :online_exam_prints do |t|
      t.integer :online_exam_id
      t.integer :user_id
      t.integer :print_count

      t.timestamps null: false
    end
  end
end
