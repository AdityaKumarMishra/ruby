class WaitlistUser < ApplicationRecord
  require 'csv'
  belongs_to :course

  def self.to_csv(waitlist_users)
    headers = ["Name", "Email"]
    CSV.generate(headers: true) do |csv|
      csv << headers
      if waitlist_users.present?
        waitlist_users.each do |user|
          csv << [
            user.name,
            user.email
          ]
        end
      end
    end
  end

end
