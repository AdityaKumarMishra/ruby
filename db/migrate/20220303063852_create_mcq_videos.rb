class CreateMcqVideos < ActiveRecord::Migration[6.1]
  def change
    drop_table(:mcq_videos, if_exists: true)
    create_table :mcq_videos do |t|
      t.belongs_to :mcq
      t.attachment :video
      t.string "title"
      t.boolean "published"
      t.string "description", default: "None"
      t.timestamps
    end
  end
end
