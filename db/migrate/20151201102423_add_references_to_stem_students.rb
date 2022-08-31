class AddReferencesToStemStudents < ActiveRecord::Migration[6.1]
  def change
    add_reference :stem_students, :user, index: true, foreign_key: true
    add_reference :stem_students, :mcq_stem, index: true, foreign_key: true
  end
end
