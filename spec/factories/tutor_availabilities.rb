# == Schema Information
#
# Table name: tutor_availabilities
#
#  id            :integer          not null, primary key
#  start_time    :datetime
#  end_time      :datetime
#  location      :text
#  tutor_profile_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :tutor_availability do
    start_time DateTime.now + 1.hour
    end_time DateTime.now + 2.hours + 1.month
    location "MyText"
    association :tutor_profile, factory: :tutor_profile
    status 0
  end
end
