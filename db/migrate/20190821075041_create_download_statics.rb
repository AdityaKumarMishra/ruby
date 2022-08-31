class CreateDownloadStatics < ActiveRecord::Migration[6.1]
  def change
    create_table :download_statics do |t|
      t.integer :file
      t.integer :download_count

      t.timestamps null: false
    end
  end
end
