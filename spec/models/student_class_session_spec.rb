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

require 'rails_helper'

RSpec.describe StudentClassSession, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:student_class_session)).to be_valid
  end

  it {should belong_to(:student_class)}
  it {should validate_presence_of(:start_time)}
  it {should validate_presence_of(:end_time)}
  it {should validate_presence_of(:student_class_id)}
end
