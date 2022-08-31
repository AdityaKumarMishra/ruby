class AddSubjecttoMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_reference :mcq_stems, :subject, index: true, foreign_key: true
  end
end
