class AddPublishedToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :published, :boolean, default: true
  end
end
