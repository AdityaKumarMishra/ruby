# == Schema Information
#
# Table name: tutor_schedules
#
#  id             :integer          not null, primary key
#  repeatability  :integer
#  start_time     :datetime
#  end_time       :datetime
#  location       :text
#  tutor_availability_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorSchedule, type: :model do
  it 'should have valid factory' do
    expect(FactoryGirl.build(:tutor_schedule)).to be_valid
  end

  it {should validate_presence_of(:start_time)}
  it {should validate_presence_of(:end_time)}
  it {should validate_presence_of(:repeatability)}
  it { should belong_to(:tutor_profile) }

  let(:tutor_schedule) {FactoryGirl.build(:tutor_schedule)}
  it { expect(tutor_schedule).to have_many :tutor_availabilities }

  describe "valid_end_time" do
    context "when end_time and start_time are blank" do
      let(:tutor_schedule1) {FactoryGirl.build(:tutor_schedule, start_time: "", end_time: "")}
      it 'should return false' do
        expect(tutor_schedule1.valid_end_time).to eq(false)
      end
    end
    context "when end_time less than start_time" do
      let(:tutor_schedule1) {FactoryGirl.build(:tutor_schedule, start_time: Date.today.next_week.to_datetime + 5.hours, end_time: Date.today.next_week.to_datetime + 3.hours, repeatability: 1)}
      it 'should validate end_time > start_time' do
        expect(tutor_schedule1.valid_end_time).to eq ["Please set later than start Date and Time"]
      end
    end
  end
end
