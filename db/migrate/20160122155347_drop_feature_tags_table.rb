class DropFeatureTagsTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :features_tags
  end
end
