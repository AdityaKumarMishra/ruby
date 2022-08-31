class AddNewFieldToOutOfStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :out_of_stocks, :content, :string
  end
end
