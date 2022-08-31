class LastMinCourse < ApplicationRecord
	validates :course_name, presence: true
	validates :amount, presence: true
	validates :description, presence: true

	# enum course_type: [:online_essentials, :online_comprehensive, :custom ]
	enum course_type: [:custom ]

	validates :course_type, presence: true
end
