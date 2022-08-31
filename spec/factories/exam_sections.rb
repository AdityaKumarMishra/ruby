# == Schema Information
#
# Table name: exam_sections
#
#  id              :integer          not null, primary key
#  title           :string
#  dificultyRating :float
#  exam_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#

FactoryGirl.define do
  factory :exam_section do
    slug { FFaker::Internet.slug }
    title "MyString"
    dificultyRating 1.5
  end

end
