class AddUniqueConstraintsOnUserNames < ActiveRecord::Migration[6.1]
  def up
    User.where("first_name IS NULL OR last_name IS NULL OR username IS NULL").each do |user|
      puts "[*] Updated user #{user.id}"
      user.first_name = "none" if user.first_name.nil?
      user.last_name = "none"  if user.last_name.nil?
      user.username = "user#{user.id}" if user.username.nil?
      user.save validate: false
    end

    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :username, false
  end

  def down
    change_column_null :users, :first_name, true
    change_column_null :users, :last_name, true
    change_column_null :users, :username, true
  end
end
