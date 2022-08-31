# == Schema Information
#
# Table name: student_class_sessions
#
#  id               :integer          not null, primary key
#  start_time       :datetime
#  end_time         :datetime
#  frequency        :integer
#  student_class_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :student_class_session do
    start_time "2015-10-13"
    end_time "2015-10-13"
    frequency 1
    student_class {FactoryGirl.create(:student_class)}
  end

end
