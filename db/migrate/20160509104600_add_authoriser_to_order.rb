class AddAuthoriserToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :authoriser_id, :integer
  end
end
