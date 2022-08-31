FactoryGirl.define do
  factory :lesson do
    date { Date.today }
    location 'Australia'
    start_time { DateTime.now }
    end_time { DateTime.now + 1 }
  end
end
