FactoryGirl.define do
  factory :section_item do
    association :section, factory: :section
    mcq nil
  end
end
