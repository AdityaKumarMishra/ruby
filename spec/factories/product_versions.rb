FactoryGirl.define do
  factory :product_version do
    slug { FFaker::Internet.slug }
    name "MyString"
    price 1.5
    type "GamsatReady"
    description "amazing description"
    course_type 2
    product_line { FactoryGirl.create(:product_line) }
  end

  factory :umat_ready, class: ProductVersion do
    name "MyString"
    price 1.5
    type "UmatReady"
    description "amazing description"
    product_line { FactoryGirl.create(:product_line) }
  end
end
