# == Schema Information
#
# Table name: student_questions
#
#  id              :integer          not null, primary key
#  question        :text
#  date_published  :datetime
#  published       :boolean
#  user_id         :integer
#  tutor_answer_id :integer
#  subject_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#

FactoryGirl.define do
  factory :student_question do
    slug { FFaker::Internet.slug }
    question "Student Question"
    date_published { DateTime.now }
    published false

    trait :with_stack do
      user_id { FactoryGirl.create(:user, :student).id }
      subject_id { FactoryGirl.create(:subject).id }
    end
  end
end
