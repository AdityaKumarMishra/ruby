FactoryGirl.define do
  factory :featurette do
    feature_enrolment factory: :feature_enrolment
    options ({'tutor_time' => 3}.to_json)
    initial_cost "9.99"
  end



end
