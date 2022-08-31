# == Schema Information
#
# Table name: video_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :video_category do
    name "MyString"
    subject {FactoryGirl.create(:subject)}
  end

end
