class AddEmailSubscriptionToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :email_subscription, :boolean, default: true
  end
  def down
    add_column :users, :email_subscription
  end
end
