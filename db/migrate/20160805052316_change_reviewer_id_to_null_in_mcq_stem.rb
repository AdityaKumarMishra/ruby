class ChangeReviewerIdToNullInMcqStem < ActiveRecord::Migration[6.1]
  def change
  	change_column :mcq_stems, :reviewer_id, :integer, null: true
  end
end
