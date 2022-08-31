class AddDirectoryToVod < ActiveRecord::Migration[6.1]
  def change
  	add_column :vods, :work_directory, :string
  end
end
