class EmailCustomise < ApplicationRecord
	require "open-uri"
	has_attached_file :attachment_name

	validates_attachment_content_type :attachment_name, content_type: 'application/pdf'
	enum greetings: ["Dear [Student First Name]", "Welcome [Student First Name]"]
	has_and_belongs_to_many :product_versions
	has_and_belongs_to_many :courses
	has_and_belongs_to_many :master_features
	before_destroy :clear_associations

 	def clear_associations
	    self.product_versions.clear
	    self.courses.clear
	    self.master_features.clear
	end

	def deep_clone
		new_email = self.dup
	    new_email.course_ids = self.course_ids
	    new_email.product_version_ids = self.product_version_ids
	    new_email.master_feature_ids = self.master_feature_ids
	    new_email.attachment_name = open(self.attachment_name.url) if self.attachment_name.file?
	    return new_email
	end
end