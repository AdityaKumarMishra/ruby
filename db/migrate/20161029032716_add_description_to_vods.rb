class AddDescriptionToVods < ActiveRecord::Migration[6.1]
  def change
    add_column :vods, :description, :string, default: 'None'
  end
end
