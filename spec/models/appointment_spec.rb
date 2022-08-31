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
require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it 'should have valid factory' do
    expect(FactoryGirl.build(:appointment)).to be_valid
    expect(FactoryGirl.build(:appointment)).to have_attributes(status: "active")
  end

  it { should respond_to(:status) }
  it { should belong_to(:tutor) }
  it { should belong_to(:student) }
  it { should have_many(:tags) }
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }
end
