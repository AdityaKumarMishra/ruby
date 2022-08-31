class CreateMockEssays < ActiveRecord::Migration[6.1]
  def up
    create_table :mock_essays do |t|

      t.attachment :essay
      t.integer :mock_exam_essay_id
      t.timestamps null: false
    end
  end

  def down
    drop_table :mock_essays
  end
end
