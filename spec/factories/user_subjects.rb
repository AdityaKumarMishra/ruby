# == Schema Information
#
# Table name: user_subjects
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active_subject_id :integer
#

FactoryGirl.define do
  factory :user_subject do
    user { FactoryGirl.create(:user, :student) }
    subject { FactoryGirl.create(:active_subject) }
  end
end
