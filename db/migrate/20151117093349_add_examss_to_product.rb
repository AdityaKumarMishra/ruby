class AddExamssToProduct < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :exam, index: true, foreign_key: true
  end
end
