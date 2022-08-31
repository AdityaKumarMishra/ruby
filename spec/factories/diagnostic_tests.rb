FactoryGirl.define do
  factory :diagnostic_test do
    title 'MyString'
    instruction 'MyText'
    published false

    # after(:build) do |test|
    #   test.section ||= FactoryGirl.build(:section, sectionable: test)
    # end
  end
end
