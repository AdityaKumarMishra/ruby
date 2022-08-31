FactoryGirl.define do
  factory :surveys_survey_question, :class => 'Surveys::SurveyQuestion' do
    survey_id {FactoryGirl.create(:surveys_survey).id}
    question "MyQuestion"
  end

end
