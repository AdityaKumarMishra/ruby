class AddItemCoverageToStudentClass < ActiveRecord::Migration[6.1]
  def change
    add_column :student_classes, :item_coverd, :text
  end
end
