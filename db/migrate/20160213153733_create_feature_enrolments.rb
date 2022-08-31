class CreateFeatureEnrolments < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_enrolments do |t|
      t.boolean :active
      t.integer :enrolment_id
      t.integer :feature_id
      t.timestamps null: false
    end
  end
end
