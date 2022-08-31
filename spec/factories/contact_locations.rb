# == Schema Information
#
# Table name: contact_locations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :contact_location do
    id 1
    name "Melbourne"
  end

end
