class EnsureAllUsersHaveAddress < ActiveRecord::Migration[6.1]
  def up
    User.all.each do |user|
      # Not atomic but should work
      next unless user.address.nil?

      puts "Adding address for user #{user.id}"
      user.address = Address.create(line_one: "unspecified", suburb: "unspecified", post_code: "0000", state: "VIC")
      user.save!(validate: false)
    end
  end

  def down
  end
end
