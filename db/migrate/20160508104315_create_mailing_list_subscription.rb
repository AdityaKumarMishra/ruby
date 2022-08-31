class CreateMailingListSubscription < ActiveRecord::Migration[6.1]
  def change
    create_table :mailing_list_subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :mailing_list, index: true, foreign_key: true
      t.string :email
      t.string :first_name
      t.string :last_name
    end
  end
end
