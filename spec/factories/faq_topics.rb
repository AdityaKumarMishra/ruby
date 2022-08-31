# == Schema Information
#
# Table name: faq_topics
#
#  id         :integer          not null, primary key
#  faq_type   :integer
#  code       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string           not null
#

FactoryGirl.define do
  factory :faq_topic do
    slug { FFaker::Internet.slug }
    faq_type 1
    title "MyString"
  end

end
