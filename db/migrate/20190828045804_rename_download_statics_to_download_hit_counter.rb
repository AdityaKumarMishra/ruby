class RenameDownloadStaticsToDownloadHitCounter < ActiveRecord::Migration[6.1]
  def change
    rename_table :download_statics, :download_hit_counters
  end
end
