FactoryGirl.define do
  factory :tagging do
    association :tag, factory: :tag
    taggable nil
  end
end
