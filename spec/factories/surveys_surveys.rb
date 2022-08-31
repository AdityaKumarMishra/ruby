FactoryGirl.define do
  factory :surveys_survey, :class => 'Surveys::Survey' do
    slug { FFaker::Internet.slug }
    title "MyTitle"
    date_published "2015-10-06 12:44:44"
    date_start "2015-10-06 12:44:44"
    published false
    date_closed "2015-10-06 12:44:44"
  end

end
