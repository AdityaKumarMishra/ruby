class AddAltTextToPosts < ActiveRecord::Migration[6.1]
  def change
  	add_column :posts, :alt_text, :string
  end
end
