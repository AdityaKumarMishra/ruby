class CreateJoinTableProductVersionFeature < ActiveRecord::Migration[6.1]
  def change
    create_join_table :product_versions, :features do |t|
      # t.index [:product_version_id, :feature_id]
      # t.index [:feature_id, :product_version_id]
    end
  end
end
