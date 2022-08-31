class CreateFeatureLists < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_lists do |t|
      t.integer :product_version_id
      t.integer :feature_id
      t.boolean :is_default

      t.timestamps null: false
    end
  end
end
