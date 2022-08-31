# == Schema Information
#
# Table name: active_subjects
#
#  id                :integer          not null, primary key
#  subject_id        :integer
#  course_version_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :active_subject do
    subject {FactoryGirl.create(:subject)}
    course_version {FactoryGirl.create(:course_version)}
  end
end
