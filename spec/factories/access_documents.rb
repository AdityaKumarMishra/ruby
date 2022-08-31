# == Schema Information
#
# Table name: access_documents
#
#  id                     :integer
#  last_accessed          :datetime
#  document_id            :integer
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#

FactoryGirl.define do
  factory :access_document do
    last_accessed "2016-04-01 21:46:07"
  end
end
