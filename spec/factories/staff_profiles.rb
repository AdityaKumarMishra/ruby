FactoryGirl.define do
  factory :staff_profile do
    staff { FactoryGirl.create :user, :tutor }
  end
end
