FactoryGirl.define do
  factory :exam_statistic do
    tag { FactoryGirl.create(:tag) }
    user { FactoryGirl.create(:user, :student) }
    section_attempt { FactoryGirl.create(:section_attempt) }
  end
end
