class AddDifficultyToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :difficulty, :integer
  end
end
