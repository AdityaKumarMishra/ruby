class CreateFeaturesInstructions < ActiveRecord::Migration[6.1]
  def change
    create_table :features_instructions do |t|
      t.string :name
      t.string :code
      t.text :content
      t.references :product_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end