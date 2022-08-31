class AddReviewedToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :reviewed, :boolean, default: false
  end
end
