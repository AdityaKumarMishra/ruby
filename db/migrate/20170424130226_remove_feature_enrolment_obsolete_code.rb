class RemoveFeatureEnrolmentObsoleteCode < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key :featurettes, :feature_enrolments
    remove_reference :featurettes, :feature_enrolment, index: true
    remove_column :essays, :expiration_date
    drop_table :photos
    drop_table :product_package_products
    drop_table :service_specs
    drop_table :invoice_specs
    drop_table :feature_lists
    drop_table :feature_enrolments
    drop_table :products
  end

  def down
  end
end
