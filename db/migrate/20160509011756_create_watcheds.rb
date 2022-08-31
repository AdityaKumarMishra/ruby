class CreateWatcheds < ActiveRecord::Migration[6.1]
  def change
    create_table :watcheds do |t|
      t.belongs_to :vod, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
