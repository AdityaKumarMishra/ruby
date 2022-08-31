class CreateOutOfStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :out_of_stocks do |t|
    	t.belongs_to :user
      t.belongs_to :textbook
      t.boolean :out_of_stock, default: false
      t.timestamps null: false
    end
  end
end
