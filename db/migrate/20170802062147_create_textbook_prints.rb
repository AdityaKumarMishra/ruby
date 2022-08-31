class CreateTextbookPrints < ActiveRecord::Migration[6.1]
  def change
    create_table :textbook_prints do |t|

      t.references :textbook
      t.references :user
      t.integer :print_count

      t.timestamps null: false
    end
  end
end
