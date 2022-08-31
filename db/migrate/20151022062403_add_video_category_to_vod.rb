class AddVideoCategoryToVod < ActiveRecord::Migration[6.1]
  def change
    add_reference :vods, :video_category, index: true, foreign_key: true
  end
end
