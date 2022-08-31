class AssignAddresses < ActiveRecord::Migration[6.1]
  def up
    User.where.not(id: Address.where(addresable_type: "User").select(:addresable_id)).each do | user|
      user.create_address(number: 1, street_name: "blank", street_type: "blank", suburb: "blank", city: "blank", post_code: "0000", state: "VIC", country: "Australia",
                          line_one: "blank", line_two: "blank")
    end
  end

  def down

  end
end
