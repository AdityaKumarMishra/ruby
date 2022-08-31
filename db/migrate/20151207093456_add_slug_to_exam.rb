class AddSlugToExam < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :slug, :string
    add_index :exams, :slug, unique: true
  end
end
