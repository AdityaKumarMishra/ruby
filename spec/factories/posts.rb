FactoryGirl.define do
  factory :post do
    name { FFaker::Internet.slug }
    description { FFaker::HTMLIpsum.body }
    blog_type "gamsat"
  end
end
