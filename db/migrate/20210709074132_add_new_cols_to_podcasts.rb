class AddNewColsToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :title_tag, :string
    add_column :podcasts, :meta_description, :text
  end
end
