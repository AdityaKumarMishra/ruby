# == Schema Information
#
# Table name: textbooks
#
#  id                    :integer          not null, primary key
#  title                 :string
#  document_file_name    :string
#  document_content_type :string
#  document_file_size    :integer
#  document_updated_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryGirl.define do
  factory :textbook do
    title "MyString"
    document_file_name "test.pdf"
    document_content_type "application/pdf"
    document_file_size 1055736
    document_updated_at {DateTime.now}
    tags { create_list :tag, 1, :with_staffs }
  end

end
