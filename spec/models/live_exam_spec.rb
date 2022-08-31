require 'rails_helper'

RSpec.describe LiveExam, type: :model do
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:course) { FactoryGirl.create(:course, product_version_id: productVer.id) }
  subject!(:live_exam) { FactoryGirl.create(:live_exam, user_id:
    student.id, course_id: course.id, section_type: 'GamsatReady') }
  it { should belong_to(:user) }
  it { should belong_to(:course) }
  it { expect(live_exam).to validate_presence_of :section_one_score }
  it { expect(live_exam).to validate_presence_of :section_two_score }
  it { expect(live_exam).to validate_presence_of :section_three_score }
  it { expect(live_exam).to validate_presence_of :user_id }
  it { expect(live_exam).to validate_presence_of :course_id }
  it { expect(live_exam).to validate_presence_of :section_type }

  let!(:live_exam1) { FactoryGirl.create(:live_exam, section_one_score: 25, section_two_score: 25, section_three_score: 25, user_id: student.id, course_id: course.id, section_type: 'GamsatReady') }

  let!(:live_exam2) { FactoryGirl.create(:live_exam, section_one_score: 75, section_two_score: 75, section_three_score: 75, user_id: student.id, course_id: course.id, section_type: 'GamsatReady') }

  let!(:live_exam3) { FactoryGirl.create(:live_exam, section_one_score: 50, section_two_score: 50, section_three_score: 50, user_id: student.id, course_id: course.id, section_type: 'GamsatReady') }

  describe '#section_one_number_of_below_rank' do
    it 'should return less section one score' do
      expect(live_exam.section_one_number_of_below_rank).to eq(1)
    end
  end

  describe '#section_one_number_of_same_rank' do
    it 'should return same section one score' do
      expect(live_exam.section_one_number_of_same_rank).to eq(2)
    end
  end

  describe '#number_of_attempts' do
    it 'should return number of students enter scores in section type' do
      expect(live_exam.number_of_attempts).to eq(4)
    end
  end

  describe '#section_two_number_of_below_rank' do
    it 'should return less section two score' do
      expect(live_exam.section_two_number_of_below_rank).to eq(1)
    end
  end

  describe '#section_two_number_of_same_rank' do
    it 'should return same section two score' do
      expect(live_exam.section_two_number_of_same_rank).to eq(2)
    end
  end

  describe '#section_three_number_of_below_rank' do
    it 'should return less section three score' do
      expect(live_exam.section_three_number_of_below_rank).to eq(1)
    end
  end

  describe '#section_three_number_of_same_rank' do
    it 'should return same section three score' do
      expect(live_exam.section_three_number_of_same_rank).to eq(2)
    end
  end

  describe '#number_of_below_rank' do
    it 'should return scores number whose total less than' do
      expect(live_exam.number_of_below_rank).to eq(1)
    end
  end

  describe '#number_of_same_rank' do
    it 'should return scores number whose total is equal' do
      expect(live_exam.number_of_same_rank).to eq(2)
    end
  end
end
