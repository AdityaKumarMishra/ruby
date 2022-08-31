class CreateEmailCustomisesProductVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :email_customises_product_versions do |t|
    	t.integer :email_customise_id
    	t.integer :product_version_id
    end
  end
end
