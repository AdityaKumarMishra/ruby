class AddAutorToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_reference :mcq_stems, :author, index: true
  end
end
