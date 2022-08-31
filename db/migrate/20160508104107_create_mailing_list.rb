class CreateMailingList < ActiveRecord::Migration[6.1]
  def change
    create_table :mailing_lists do |t|
      t.string :name, index: { unique: true }, null: false
    end
  end
end
