class CreateFeatureLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_logs do |t|
      t.datetime :acquired
      t.datetime :suspended
      t.integer :qty
      t.text :description
      t.belongs_to :product_version_feature_price, index: true
      t.belongs_to :enrolment, index: true
      t.timestamps null: false
    end
  end
end
