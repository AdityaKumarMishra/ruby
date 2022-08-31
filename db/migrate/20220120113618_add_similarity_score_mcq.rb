class AddSimilarityScoreMcq < ActiveRecord::Migration[6.1]
  def change
  	add_column :mcqs, :similarity_score, :integer
  	add_column :mcq_stems, :similarity_score, :integer

  end
end
