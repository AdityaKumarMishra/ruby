class AddExamSectionToMcq < ActiveRecord::Migration[6.1]
  def change
    add_reference :mcqs, :exam_section, index: true, foreign_key: true
  end
end
