# == Schema Information
#
# Table name: tutor_availabilities
#
#  id            :integer          not null, primary key
#  start_time    :datetime
#  end_time      :datetime
#  location      :text
#  tutor_profile_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorAvailability, type: :model do
  subject(:tutor_availability) { FactoryGirl.create(:tutor_availability) }
  it 'should have valid factory' do
    expect(tutor_availability).to be_valid
    expect(tutor_availability).to have_attributes(status: "active")
  end
  it { should respond_to(:status) }
  it {should have_one(:tutor)}
  it {should validate_presence_of(:start_time)}
  it {should validate_presence_of(:end_time)}
  it { should belong_to(:tutor_schedule) }

  describe "#tutor_tags" do
    let!(:tutor) {FactoryGirl.create :user}
    let!(:tutor_profile) {FactoryGirl.create :tutor_profile, tutor_id: tutor.id}
    let!(:staff_profile1) {FactoryGirl.create :staff_profile, staff_id: tutor.id}
    let!(:tutor_availability1) {FactoryGirl.create :tutor_availability, tutor_profile_id: tutor_profile.id}
    context "tutor availability with tags" do
      let!(:tag1) {FactoryGirl.create(:tag)}
      let!(:tagging1) {FactoryGirl.create :tagging, taggable_type: "StaffProfile", taggable_id: staff_profile1.id, tag_id: tag1.id}
      it 'should have tags associated with tutor that are associated with tutor availability' do
        expect(TutorAvailability.tutor_tags).to eq([tag1])
      end
    end
    context "tutor availability with no tags" do
      it 'should have no tags associated with tutor that are associated with tutor availability' do
        expect(TutorAvailability.tutor_tags).to eq []
      end
    end
  end

  describe "scope#with_tag" do
    context 'scopes' do
      let(:tutor_availability1) {FactoryGirl.create :tutor_availability}
      let(:tag2) {FactoryGirl.create(:tag)}
      let(:tag1) {FactoryGirl.create(:tag, parent_id: tag2.id)}
      let(:tagging1) {FactoryGirl.create(:tagging, tag_id: tag1.id, taggable_id: tutor_availability1.tutor_profile.id, taggable_type: "StaffProfile")}
      it "should return tutor availabilities according to tags" do
        expect(TutorAvailability.with_tag(tag1.id)).to eq []
      end
    end
  end

  describe "scope#with_end" do
    context 'scopes' do
      let(:tutor_availability2) {FactoryGirl.create :tutor_availability}
      it "should return tutor availabilities according to end_time" do
        expect(TutorAvailability.with_end(tutor_availability2.end_time)).to include(tutor_availability2)
      end
    end
  end

  describe "scope#with_start" do
    context 'scopes' do
      let(:tutor_availability3) {FactoryGirl.create :tutor_availability}
      it "should return tutor availabilities according to start_time" do
        expect(TutorAvailability.with_start(tutor_availability3.start_time)).to include(tutor_availability3)
      end
    end
  end
end
