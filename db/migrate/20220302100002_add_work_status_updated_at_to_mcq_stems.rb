class AddWorkStatusUpdatedAtToMcqStems < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :work_status_updated_at, :datetime
  end
end
