FactoryGirl.define do
  factory :mcq_statistic do
    tag { FactoryGirl.create(:tag) }
    user { FactoryGirl.create(:user, :student) }
  end
end
