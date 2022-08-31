# == Schema Information
#
# Table name: student_classes
#
#  id                :integer          not null, primary key
#  name              :string
#  size              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_version_id :integer
#  active_subject_id :integer
#  item_coverd       :text
#

FactoryGirl.define do
  factory :student_class do
    name "My Name"
    size 1
    subject {FactoryGirl.create(:subject)}
  end

end
