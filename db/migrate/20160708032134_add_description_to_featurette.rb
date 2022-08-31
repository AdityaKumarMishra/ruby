class AddDescriptionToFeaturette < ActiveRecord::Migration[6.1]
  def change
    add_column :featurettes, :description, :string
  end
end
