FactoryGirl.define do
  factory :course_recommender_usage do

    incomplete 2
    skip 1
    complete 3
    course_name "My Course"
    product_line "GAMSAT"
    subject "English"


  end

end
