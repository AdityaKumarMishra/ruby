class TextbookDelivery < ApplicationRecord
	enum status: ["To Be Sent", "To be packaged", "Packaged", "Sent", "N/A"]
	belongs_to :user
	belongs_to :enrolment

  def self.options_for_temporary_access
    [
      ['Yes', 'true'],
      ['No', 'false']
    ]
  end
end
