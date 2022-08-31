class AddTagAndSubjectToStemStudent < ActiveRecord::Migration[6.1]
  def change
    add_reference :stem_students, :subject, index: true, foreign_key: true
  end
end
