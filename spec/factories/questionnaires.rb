FactoryGirl.define do
  factory :questionnaire do
    year "2011"
    umat_high_school true
    umat_uni false
    source ["text"]
    last_source "text"
    student_level "university"
    current_highschool "text"
    target_uni_course "text"
    university {FactoryGirl.create(:university)}
    degree {FactoryGirl.create(:degree)}
  end

end
