# == Schema Information
#
# Table name: documents
#
#  id                       :integer
#  accessible               :boolean
#  allow_dummy              :datetime
#  only_dummy               :datetime
#  user_id                  :integer
#  attachment_file_name     :string
#  attachment_content_type  :string
#  attachment_file_size     :integer
#  attachment_updated_at    :datetime
#  created_at               :datetime
#  updated_at               :datetime
#

FactoryGirl.define do
  factory :document do
    accessible true
    for_timetable false
    product_line_id 4
    allow_dummy false
    only_dummy false
    attachment { fixture_file_upload(Rails.root.join('spec/fixtures/test_document.pdf'), 'application/pdf') }
  end
end
