class CreateFeaturettes < ActiveRecord::Migration[6.1]
  def change
    create_table :featurettes do |t|
      t.references :feature_enrolment, index: true, foreign_key: true
      t.string :options, default: "{}"
      t.decimal :initial_cost, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
