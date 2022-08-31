class AddTypeToExam < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :type, :string
  end
end
