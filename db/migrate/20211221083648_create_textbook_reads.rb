class CreateTextbookReads < ActiveRecord::Migration[6.1]
  def change
    create_table :textbook_reads do |t|
    	t.belongs_to :textbook
    	t.belongs_to :user
    	t.belongs_to :course
    	t.boolean :is_open, default: true
    	t.boolean :is_read, default: false
      t.timestamps null: false
    end
  end
end
