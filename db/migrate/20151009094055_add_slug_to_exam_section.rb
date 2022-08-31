class AddSlugToExamSection < ActiveRecord::Migration[6.1]
  def change
    add_column :exam_sections, :slug, :string
    add_index :exam_sections, :slug, unique: true
  end
end
