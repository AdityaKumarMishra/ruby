FactoryGirl.define do
  factory :essay_response, :class => 'EssayResponse' do
    slug { FFaker::Internet.slug }
    response "MyText"
    time_submited "2015-10-12 11:08:35"
    expiry_date Date.today + 10.days
    user { FactoryGirl.create(:user, :student) }
    essay { FactoryGirl.create(:essay, position: (1..10).to_a.sample, product_line_id: FactoryGirl.create(:product_line).id)}
    course {FactoryGirl.create(:course)}
  end
end
