class Shipping < ApplicationRecord

  enum country: {
    "Africa": 'africa',
    "Australia": 'australia',
    "Asia Pacific": 'asia_pacific',
    "Europe": 'europe',
    "Americas": 'americas',
    "New Zealand": 'new_zealand'
  }
end
