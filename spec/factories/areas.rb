# == Schema Information
#
# Table name: areas
#
#  id               :integer          not null, primary key
#  city             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  institution_name :string
#

FactoryGirl.define do
  sequence(:city) { |n| "City #{n}" }

  factory :area do
    city
  end

end
