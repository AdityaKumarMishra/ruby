class AddTimestampToMailingListSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :mailing_list_subscriptions, :created_at, :datetime
    add_column :mailing_list_subscriptions, :updated_at, :datetime
  end
end
