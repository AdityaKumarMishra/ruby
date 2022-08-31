class AddEnquiryUserToComment < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :enquiry_user_id, :integer
  end

  def down
  	remove_column :comments, :enquiry_user_id
  end
end
