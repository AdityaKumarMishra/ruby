#
# Table name: job_descriptions
#  id                  :integer          not null, primary key
#  job_application_form_id    :integer
#  document_file_name  :string
#  document_content_type :string
#  document_file_size  :integer
#  document_updated_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class JobDescription < ApplicationRecord
  belongs_to :job_application_form

  has_attached_file :document

  validates_attachment_content_type :document, content_type: [ 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'], message: 'Invalid file type'
end
