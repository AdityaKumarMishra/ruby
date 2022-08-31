FactoryGirl.define do
  factory :ticket_answer do
    content 'MyText'
    association :ticket, factory: :ticket
    association :user, factory: :user
    public false
  end
end
