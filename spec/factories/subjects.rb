# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#  course_id   :integer
#

FactoryGirl.define do
  factory :subject do
    slug { FFaker::Internet.slug }
    title { FFaker::Education.major }
    description "Subject Description"

    trait :with_course do
      course_id { FactoryGirl.create(:course).id }
    end
  end
end
