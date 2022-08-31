# == Schema Information
#
# Table name: tutor_answers
#
#  id             :integer          not null, primary key
#  answer         :text
#  date_published :datetime
#  published      :boolean
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :tutor_answer do
    answer "Tutor Answer"
    date_published { DateTime.now }
    published false

    trait :with_user do
      user_id { FactoryGirl.create(:user, :tutor).id }
    end
  end
end
