class AddUniqueConstraintToMcqStemTitle < ActiveRecord::Migration[6.1]
  def change
    add_index :mcq_stems, :title, unique: true
  end
end
