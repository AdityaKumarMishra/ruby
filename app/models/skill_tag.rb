class SkillTag < ApplicationRecord
	has_many :mcq_stems
	has_many :mcqs

	def self.options_for_select
    	order('LOWER(tag_name)').map { |e| [e.tag_name, e.id] }
  	end
end
