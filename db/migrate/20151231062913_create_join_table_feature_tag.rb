class CreateJoinTableFeatureTag < ActiveRecord::Migration[6.1]
  def change
    create_join_table :features, :tags do |t|
      # t.index [:feature_id, :tag_id]
      # t.index [:tag_id, :feature_id]
    end
  end
end
