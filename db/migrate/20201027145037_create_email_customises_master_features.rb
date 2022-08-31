class CreateEmailCustomisesMasterFeatures < ActiveRecord::Migration[6.1]
  def change
    create_table :email_customises_master_features do |t|
    	t.integer :email_customise_id
    	t.integer :master_feature_id
    end
  end
end
