class CreateCommonContents < ActiveRecord::Migration[6.1]
  def change
    create_table :common_contents do |t|

      t.timestamps null: false
      t.string :contact_number
      t.date :mock_exam_overdue
    end
  end
end
