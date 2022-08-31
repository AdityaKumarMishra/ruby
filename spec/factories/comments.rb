FactoryGirl.define do
  factory :comment do
    association :user, factory: :user
    association :commentable, factory: :ticket_answer
    content 'MyText'
  end
end
