FactoryGirl.define do
  factory :master_feature do
    name 'GamsatEssayFeature'
    types ['GamsatReady']
    partials ['pages/partial/gamsat_ready_features/marked_essays']
    url 'essay_responses_path'
    show_in_sidebar true
  end

  trait :hardcopy do
  	name 'GamsatTextbookHardcopyFeature'
  end
end
