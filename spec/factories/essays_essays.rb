FactoryGirl.define do
  factory :essay, :class => 'Essay' do
    slug { FFaker::Internet.slug }
    title "MyString"
    question "MyText"
    date_added "2015-10-09 16:43:32"
    tutor_id { FactoryGirl.create(:user, :tutor).id }
  end

end
