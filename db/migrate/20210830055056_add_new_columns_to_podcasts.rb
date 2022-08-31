class AddNewColumnsToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :audio_url, :text
    add_column :podcasts, :audio_name, :string
  end
end
