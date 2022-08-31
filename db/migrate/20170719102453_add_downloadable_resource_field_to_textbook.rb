class AddDownloadableResourceFieldToTextbook < ActiveRecord::Migration[6.1]
  def change
    add_column :textbooks, :for_downloadable_resource, :boolean, default: false
    add_column :textbooks, :for_paid, :boolean
    add_column :textbooks, :for_trial, :boolean
  end
end
