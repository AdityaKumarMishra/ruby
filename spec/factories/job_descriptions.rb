#
# Table name: job_descriptions
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

FactoryGirl.define do
  factory :job_description do
    document { fixture_file_upload(Rails.root.join('spec/fixtures/test_document.pdf'), 'application/pdf') }
  end
end
