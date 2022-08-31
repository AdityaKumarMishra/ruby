# == Schema Information
#
# Table name: tutor_schedules
#
#  id             :integer          not null, primary key
#  repeatability  :integer
#  start_time     :datetime
#  end_time       :datetime
#  location       :text
#  tutor_availability_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :tutor_schedule do
    repeatability 0
    start_time Date.today.next_week.to_datetime + 3.hours
    end_time Date.today.next_week.to_datetime + 5.hours
    location "MyText"
  end

end
