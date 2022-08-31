class AddMostPopularToMasterFetaures < ActiveRecord::Migration[6.1]
  def change
    add_column :master_features, :most_popular, :boolean, default: false
    add_column :master_features, :popular_order, :integer
  end
end
