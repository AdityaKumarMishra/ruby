class CreateCompletedTextbooks < ActiveRecord::Migration[6.1]
  def change
    create_table :completed_textbooks do |t|
      t.belongs_to :textbook, index: true
      t.belongs_to :user, index: true
      t.integer :course_id
      t.timestamps null: false
    end
  end
end
