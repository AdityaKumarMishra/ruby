class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def validate_work_directory
  	errors.add(:work_directory, "Individual documents are not accepted in the Work Directory field. Please link the appropriate folder which corresponds to this Unit") if work_directory&.include? 'docs.google.com/document'
  end
end