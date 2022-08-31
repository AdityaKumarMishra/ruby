class Notification < ApplicationRecord
	enum page_type: [:course_details]
	validates :page_type, uniqueness: true, presence: true
end
