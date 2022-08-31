class AddSubscribeEmailToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :private_tutor_subscribe_email, :boolean, default: false
  end
end
