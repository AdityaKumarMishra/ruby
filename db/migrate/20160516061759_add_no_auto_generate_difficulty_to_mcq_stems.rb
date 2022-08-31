class AddNoAutoGenerateDifficultyToMcqStems < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :autogenerate_difficulty, :boolean, null: false, default: true
  end
end