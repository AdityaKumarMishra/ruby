# == Schema Information
#
# Table name: course_addresses
#
#  id               :integer          not null, primary key
#  number           :integer
#  street_name      :string
#  street_type      :string
#  subburb          :string
#  post_code        :string
#  state            :string
#  country          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  city             :string
#  institution_name :string
#

FactoryGirl.define do
  factory :course_address do
    area nil
  end

end
