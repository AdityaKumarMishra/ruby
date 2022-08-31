FactoryGirl.define do
  factory :ticket do
    title 'MyString'
    question 'MyText'
    first_name 'first_name'
    last_name 'last_name'
    email 'test@abc.com'
    subtitle 'subtitle'
    phone_number '9874563210'
    association :asker, factory: :user
    association :answerer, factory: [:user, :tutor]
    #association :tags, factory: :tag
    after(:build) do |ticket|

      # Create tags unless they're manually specified
      if ticket.tags.empty?
        ticket.tags = create_list(:tag, 2)
      end
    end
    public false
    answered_at '2016-03-11 00:28:45'
    questionable nil
  end
end
