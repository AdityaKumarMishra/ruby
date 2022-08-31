#
# Table name: cover_letters
#
#  id                  :integer          not null, primary key
#  job_application_id    :integer
#  document_file_name  :string
#  document_content_type :string
#  document_file_size  :integer
#  document_updated_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CoverLetter < ApplicationRecord
  belongs_to :job_application

  has_attached_file :document

  validates_attachment_presence :document, message: 'Please include a cover letter'
  validates_attachment_content_type :document, content_type: [ 'application/pdf'], message: 'Invalid file type'
end
