# == Schema Information
#
# Table name: job_application_forms
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :text
#  open                :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :job_application_form do
    title "MyString"
    description "MyText"
    open true
  end

end
