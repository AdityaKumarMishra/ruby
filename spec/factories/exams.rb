# == Schema Information
#
# Table name: exams
#
#  id            :integer          not null, primary key
#  date_started  :datetime
#  date_finished :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  subject_id    :integer
#  examType      :string
#

FactoryGirl.define do
  factory :exam do
    date_started "2015-10-07 17:45:52"
    date_finished "2015-10-07 17:45:53"
    type "Exam"
    association :subject, factory: :subject
  end
end
