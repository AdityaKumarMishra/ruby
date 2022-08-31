class CreateUserVideos < ActiveRecord::Migration[6.1]
  def change
    drop_table(:user_videos, if_exists: true)
    create_table :user_videos do |t|
      t.belongs_to :mcq_video
      t.belongs_to :mcq
      t.belongs_to :user
      t.timestamps
    end
  end
end
