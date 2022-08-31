class CoursePage < ApplicationRecord
	before_save :change_page_activity

	private
	
	def change_page_activity
		CoursePage.where.not(id: id).update_all(active_page: false)
	end
end
