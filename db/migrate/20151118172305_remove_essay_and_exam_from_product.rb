class RemoveEssayAndExamFromProduct < ActiveRecord::Migration[6.1]
  def change
    remove_reference :products, :essay, index: true, foreign_key: true
    remove_reference :products, :exam, index: true, foreign_key: true
  end
end
