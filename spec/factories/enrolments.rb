# == Schema Information
#
# Table name: enrolments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  new_course_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :enrolment do
    association :course, factory: :course
    paid_at Time.zone.now
    paypal_token 'some token'
    paypal_payment 'some payment id'
  end
end
