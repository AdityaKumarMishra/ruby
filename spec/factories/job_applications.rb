# == Schema Information
#
# Table name: job_applications
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  last_name           :string
#  phone_number        :string
#  email               :string
#  job_application_form_id  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


FactoryGirl.define do
  factory :job_application do

    name FFaker::Name.name
    association :address, factory: :address
    phone_number "9874563210"
    email FFaker::Internet.email
    hours_available "12"
    degree_type "PhD"
    degree "Bachelor of Computer Science"
    graduation "201612"
    atar "98.5"
    wam "76"
    domestic false
    resume { FactoryGirl.create(:resume) }
    cover_letter { FactoryGirl.create(:cover_letter) }

  end

end
