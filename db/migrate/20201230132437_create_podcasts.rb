class CreatePodcasts < ActiveRecord::Migration[6.1]
  def change
    create_table :podcasts do |t|
    	t.string :slug, :unique => true
    	t.string :title
    	t.attachment :image
    	t.date :uploaded_on
    	t.string :duration
    	t.text :ep_desc
    	t.text :full_desc
    	t.text :frame_url
      t.timestamps null: false
    end
    add_index :podcasts, :slug, :unique => true
  end
end
