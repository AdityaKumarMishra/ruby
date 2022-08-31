FactoryGirl.define do
  factory :surveys_survey_answer, :class => 'Surveys::SurveyAnswer' do
    user {FactoryGirl.create(:user).id}
    survey_question {FactoryGirl.create(:surveys_survey_question).id}
    answer "MyAnswer"
    rating 1
  end

end
