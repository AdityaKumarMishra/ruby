class AddSetsToMcq < ActiveRecord::Migration[6.1]
  def change
    add_reference :mcqs, :mcq_set, index: true, foreign_key: true
  end
end
