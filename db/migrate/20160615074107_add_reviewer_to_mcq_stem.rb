class AddReviewerToMcqStem < ActiveRecord::Migration[6.1]
  def up
    add_column :mcq_stems, :reviewer_id, :integer
  end

  def down
    remove_column :mcq_stems, :reviewer_id, :integer
  end
end

