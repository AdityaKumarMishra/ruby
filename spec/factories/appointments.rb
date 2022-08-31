# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  tutor_availability_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


FactoryGirl.define do
  factory :appointment do
    location "MyText"
    status 0
    tutor_id { FactoryGirl.create(:user, :tutor).id }
  end
end
