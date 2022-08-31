class AddProductToAnnouncements < ActiveRecord::Migration[6.1]
  def change
  	 add_column :announcements, :product, :string
  end
end
