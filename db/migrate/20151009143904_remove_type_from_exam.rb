class RemoveTypeFromExam < ActiveRecord::Migration[6.1]
  def change
    remove_column :exams, :type
    add_column :exams, :examType, :string
  end
end
