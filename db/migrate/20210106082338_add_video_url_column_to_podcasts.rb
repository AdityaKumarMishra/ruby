class AddVideoUrlColumnToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :video_url, :text
  end
end
