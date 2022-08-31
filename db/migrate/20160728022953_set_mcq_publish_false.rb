class SetMcqPublishFalse < ActiveRecord::Migration[6.1]
  def change
    change_column :mcq_stems, :published, :boolean, :default => false
  end
end
