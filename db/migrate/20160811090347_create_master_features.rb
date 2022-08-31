class CreateMasterFeatures < ActiveRecord::Migration[6.1]
  def change
    create_table :master_features do |t|
      t.string :name
      t.string :location
      t.text :partials, array: true, default: []
      t.string :types, array: true, default: []
      t.timestamps null: false
    end
  end
end
