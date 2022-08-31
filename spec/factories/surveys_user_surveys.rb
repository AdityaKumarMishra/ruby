FactoryGirl.define do
  factory :surveys_user_survey, :class => 'Surveys::UserSurvey' do
    user ""
survey ""
is_submited false
  end

end
