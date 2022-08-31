class AddVideoNameColToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :video_name, :string
  end
end
