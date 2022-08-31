class AddProductLineToExamsAndEssays < ActiveRecord::Migration[6.1]
  def up
    add_column :essays, :product_line_id, :integer, index: true
    add_column :online_exams, :product_line_id, :integer, index: true
  end
end
