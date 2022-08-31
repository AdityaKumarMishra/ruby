class AddProfileImage < ActiveRecord::Migration[6.1]
  def change
    add_attachment :users, :profile_image
  end
end
