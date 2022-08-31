require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { FactoryGirl.create :course, :with_enrolment }
  describe '#destroy' do
    it 'should not violate foreign keys' do
      expect { course.destroy }.not_to raise_error
    end
  end

  describe '#course_full?' do
    subject { course.course_full? }

    context 'exceeded class size' do
      before(:each) do
        course.class_size = 1
        enrolment1 =FactoryGirl.create :enrolment, course: course
        enrolment2 = FactoryGirl.create :enrolment, course: course
        order = FactoryGirl.create :order, status: 3
        p1 = FactoryGirl.create :purchase_item, purchasable: enrolment1, order: order
        p2 = FactoryGirl.create :purchase_item, purchasable: enrolment2, order: order
        course.save
      end

      it { is_expected.to be true }
    end

    context 'within class size' do
      before(:each) do
        course.class_size = 2
        course.save
      end

      it { is_expected.to be false }
    end
  end

  describe '#tutor_assigned?' do
    it 'return no' do
      expect(course.tutor_assigned?).to eq 'None'
    end

    it 'retutn yes' do
      course = FactoryGirl.create :course, :with_enrolment
      course_staff = FactoryGirl.create :course_staff, course: course
      staff_name = course_staff.staff_profile.staff.full_name
      expect(course.tutor_assigned?).to eq staff_name
    end
  end

  describe '#options_for_city' do
    it 'returns all cities of a course' do
      city = city
      allow(city).to receive(:course).and_return('Melbourne', 'Sydney', 'Brisbane', 'Adelaide', 'Perth', 'Canberra', 'Sept-GAMSAT Melbourne', 'Sept-GAMSAT Sydney', 'Sept-GAMSAT Brisbane', 'Sept-GAMSAT Adelaide', 'Sept-GAMSAT Perth', 'Other')
      expect(city.course).to eq('Melbourne')
      expect(city.course).to eq('Sydney')
      expect(city.course).to eq('Brisbane')
      expect(city.course).to eq('Adelaide')
      expect(city.course).to eq('Perth')
      expect(city.course).to eq('Canberra')
      expect(city.course).to eq('Sept-GAMSAT Melbourne')
      expect(city.course).to eq('Sept-GAMSAT Sydney')
      expect(city.course).to eq('Sept-GAMSAT Brisbane')
      expect(city.course).to eq('Sept-GAMSAT Adelaide')
      expect(city.course).to eq('Sept-GAMSAT Perth')
      expect(city.course).to eq('Other')
    end
  end
end
