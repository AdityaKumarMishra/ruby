class AddExamNameToFeatureLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :feature_logs, :exam_name, :string
  end
end
