class ValidateTutorProfile < ActiveRecord::Migration[6.1]
  def change
    User.where.not(role:0).each do |user|
        user.validate_tutor_profile
        user.validate_staff_profile
      end
  end
end
