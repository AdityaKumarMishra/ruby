class AddColumnsMcqs < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :video_explainer_id, :integer
    add_column :mcq_stems, :video_reviewer_id, :integer
  end
end
